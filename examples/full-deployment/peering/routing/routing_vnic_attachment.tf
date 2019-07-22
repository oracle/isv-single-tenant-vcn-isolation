

module routing_instance_1_peering_1_vnic_attachement {
  source         = "../../../../modules/routing_vnic_attachment"
  hostname_label = "${module.routing_instance_1.instance.hostname_label}"
  display_name   = "${module.routing_instance_1.instance.hostname_label} peering interface 1"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance_1.instance.id
  subnet_id = data.terraform_remote_state.peering_network.outputs.peering_1_network.peering_subnet.id

  ssh_host     = module.routing_instance_1.instance.private_ip
  bastion_host = local.bastion_ip
}

/* FIXME
module routing_instance_1b_peering_1_vnic_attachement {
  source         = "../../../../modules/routing_vnic_attachment"
  hostname_label = "${module.routing_instance_1.instance_b.hostname_label}"
  display_name   = "${module.routing_instance_1.instance_b.hostname_label} peering interface 1"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance_1.instance_b.id
  subnet_id = data.terraform_remote_state.peering_network.outputs.peering_1_network.peering_subnet.id 

  ssh_host     = module.routing_instance_1.instance_b.private_ip
  bastion_host = local.bastion_ip
}

resource oci_core_private_ip routing_instance_1_peering_1_floating_ip {
  vnic_id        = module.routing_instance_1a_peering_1_vnic_attachement.routing_secondary_vnic_id
  hostname_label = "gateway1"

  lifecycle {
    ignore_changes = [
      # ignore changes to vnic_id as it can be moved dynamically for HA failover
      vnic_id,
    ]
  }
}
*/

# TODO disabled additional interface
#  - using VM.Standard2.1 shape for testing with just one secondary vnic
/*
module routing_instance_1_peering_2_vnic_attachement {
  source         = "../../../../modules/routing_vnic_attachment"
  hostname_label = "${module.routing_instance_1.instance1.hostname_label}"
  display_name   = "${module.routing_instance_1.instance1.hostname_label} peering interface 2"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance_1.instance1.id
  subnet_id = data.terraform_remote_state.peering_network.outputs.peering_2_network.peering_subnet.id 

  ssh_host     = module.routing_instance_1.instance1.private_ip
  bastion_host = local.bastion_ip
}

module routing_instance_1b_peering_2_vnic_attachement {
  source         = "../../../../modules/routing_vnic_attachment"
  hostname_label = "${module.routing_instance_2.instance_a.hostname_label}"
  display_name   = "${module.routing_instance_2.instance_a.hostname_label} peering interface 2"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance_1.instance1.id
  subnet_id = data.terraform_remote_state.peering_network.outputs.peering_2_network.peering_subnet.id 

  ssh_host     = module.routing_instance_1.instance1.private_ip
  bastion_host = local.bastion_ip
}

resource oci_core_private_ip routing_instance_1_peering_2_floating_ip {
  vnic_id        = module.routing_instance_1a_peering_2_vnic_attachement.routing_secondary_vnic_id
  hostname_label = module.routing_instance_1a_peering_2_vnic_attachement.hostname_label

  lifecycle {
    ignore_changes = [
      # ignore changes to vnic_id as it can be moved dynamically for HA failover
      vnic_id,
    ]
  }
}
*/


/* FIXME
module routing_instance_2_peering_1_vnic_attachement {
  source         = "../../../../modules/routing_vnic_attachment"
  hostname_label = "${module.routing_instance_2.instance.hostname_label}"
  display_name   = "${module.routing_instance_2.instance.hostname_label} peering interface 1"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance_2.instance_a.id
  subnet_id = data.terraform_remote_state.peering_network.outputs.peering_2_network.peering_subnet.id

  ssh_host     = module.routing_instance_2.instance.private_ip
  bastion_host = local.bastion_ip
}

module routing_instance_2b_peering_1_vnic_attachement {
  source         = "../../../../modules/routing_vnic_attachment"
  hostname_label = "${module.routing_instance_2.instance_b.hostname_label}"
  display_name   = "${module.routing_instance_2.instance_b.hostname_label} peering interface 1"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance_2.instance_b.id
  subnet_id = data.terraform_remote_state.peering_network.outputs.peering_2_network.peering_subnet.id

  ssh_host     = module.routing_instance_2.instance_b.private_ip
  bastion_host = local.bastion_ip
}

resource oci_core_private_ip routing_instance_2_peering_1_floating_ip {
  vnic_id        = module.routing_instance_2a_peering_1_vnic_attachement.routing_secondary_vnic_id
  hostname_label = "gateway2"

  lifecycle {
    ignore_changes = [
      # ignore changes to vnic_id as it can be moved dynamically for HA failover
      vnic_id,
    ]
  }
}
*/


##########
########## IP Route Add ###########################
##########
module routing_instance_1_peering_1_routes {
  source = "../../../../modules/ip_route_add"

  vnic_id = module.routing_instance_1_peering_1_vnic_attachement.routing_secondary_vnic_id

  peering_subnet_cidr = data.terraform_remote_state.configuration.outputs.peering_vcns[0]
  tenant_vcn_cidrs    = data.terraform_remote_state.configuration.outputs.tenant_vcns_per_peering_vcn[0]

  bastion_host = local.bastion_ip
  ssh_host     = module.routing_instance_1.instance.private_ip
}

/* FIXME
module routing_instance_1b_peering_1_routes {
  source = "../../../../modules/ip_route_add"

  vnic_id = module.routing_instance_1b_peering_1_vnic_attachement.routing_secondary_vnic_id

  peering_subnet_cidr = (length(data.terraform_remote_state.configuration.outputs) == 0 ? null : data.terraform_remote_state.configuration.outputs.peering_vcns[0])
  tenant_vcn_cidrs    = (length(data.terraform_remote_state.configuration.outputs) == 0 ? null : data.terraform_remote_state.configuration.outputs.tenant_vcns_per_peering_vcn[0])

  bastion_host = local.bastion_ip
  ssh_host     = module.routing_instance_1.instance_b.private_ip
}
*/

/* FIXME
module ip_route_add_instance2 {
  source = "../../../../modules/ip_route_add"

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
*/

output ip_route_add_status {
  value = "IP Route Add successfull"
}