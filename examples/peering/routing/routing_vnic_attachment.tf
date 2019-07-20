

module routing_vnic_attachement1 {
  source         = "../../../modules/routing_vnic_attachment"
  hostname_label = "gateway1vnic1"
  display_name   = "${module.routing_instance.instance1.hostname_label} peering interface"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance.instance1.id
  subnet_id = lookup(data.terraform_remote_state.peering_network.outputs, "peering_1_subnet_id", null)

  ssh_host     = module.routing_instance.instance1.private_ip
  bastion_host = local.bastion_ip
}

module routing_vnic_attachement2 {
  source         = "../../../modules/routing_vnic_attachment"
  hostname_label = "gateway1vnic2"
  display_name   = "${module.routing_instance.instance1.hostname_label} peering interface"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance.instance2.id
  subnet_id = lookup(data.terraform_remote_state.peering_network.outputs, "peering_1_subnet_id", null)

  ssh_host     = module.routing_instance.instance2.private_ip
  bastion_host = local.bastion_ip
}


resource oci_core_private_ip floating_peering_ip {
  vnic_id        = module.routing_vnic_attachement1.routing_secondary_vnic_id
  hostname_label = module.routing_instance.hostname_label

  lifecycle {
    ignore_changes = [
      # ignore changes to vnic_id as it can be moved dynamically for HA failover
      vnic_id,
    ]
  }
}

output routing_secondary_vnic_ids {
  value = [
    module.routing_vnic_attachement1.routing_secondary_vnic_id,
    module.routing_vnic_attachement2.routing_secondary_vnic_id,
  ]
}


##########
########## IP Route Add ###########################
##########
module ip_route_add_instance1 {
  source = "../../../modules/ip_route_add"

  compartment_id = local.compartment_id

  vnic_id = module.routing_vnic_attachement1.routing_secondary_vnic_id

  bastion_host = local.bastion_ip
  ssh_host = module.routing_instance.instance1.private_ip

  peering_1_subnet_cidr   = lookup(data.terraform_remote_state.peering_network.outputs, "peering_1_subnet_cidr", null)
  tenant_1_vcn_cidr_block = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_1_vcn_cidr", null)
  tenant_2_vcn_cidr_block = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_2_vcn_cidr", null)
  # TODO scale out
  # peering_2_subnet_cidr   = lookup(data.terraform_remote_state.peering_network.outputs, "peering_2_subnet_cidr", null)
  # tenant_3_vcn_cidr_block = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_3_vcn_cidr", null)
  # tenant_4_vcn_cidr_block = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_4_vcn_cidr", null)

  peering_1_vnic_id = "${module.routing_vnic_attachement1.routing_secondary_vnic_id}"
  # TODO scale out
  # peering_2_vnic_id         = "${module.routing_vnic_attachement1.routing_secondary_vnic_id}"
}

module ip_route_add_instance2 {
  source = "../../../modules/ip_route_add"

  compartment_id = local.compartment_id

  vnic_id = module.routing_vnic_attachement2.routing_secondary_vnic_id

  bastion_host = local.bastion_ip
  ssh_host = module.routing_instance.instance2.private_ip

  peering_1_subnet_cidr   = lookup(data.terraform_remote_state.peering_network.outputs, "peering_1_subnet_cidr", null)
  tenant_1_vcn_cidr_block = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_1_vcn_cidr", null)
  tenant_2_vcn_cidr_block = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_2_vcn_cidr", null)
  # TODO scale out
  # peering_2_subnet_cidr   = lookup(data.terraform_remote_state.peering_network.outputs, "peering_2_subnet_cidr", null)
  # tenant_3_vcn_cidr_block = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_3_vcn_cidr", null)
  # tenant_4_vcn_cidr_block = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_4_vcn_cidr", null)

  peering_1_vnic_id = "${module.routing_vnic_attachement2.routing_secondary_vnic_id}"
  # TODO scale out
  # peering_2_vnic_id         = "${module.routing_vnic_attachement1.routing_secondary_vnic_id}"
}


output ip_route_add_status {
  value = "IP Route Add successfull"
}