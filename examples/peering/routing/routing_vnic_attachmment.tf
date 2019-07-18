
module routing_vnic_attachement1 {
  source = "../../../modules/routing_vnic_attachment"

  display_name              = "${module.routing_instance.instance1.hostname_label} peering interface"
  compartment_id            = local.compartment_id
  bastion_ip                = local.bastion_ip
  routing_ip                = module.routing_instance.instance1.private_ip
  routing_instance_id       = module.routing_instance.instance1.id
  hostname_label            = module.routing_instance.instance1.hostname_label
  peering_subnet_cidr       = lookup(data.terraform_remote_state.peering_network.outputs, "peering_subnet_cidr", null)
  peering_subnet_id         = lookup(data.terraform_remote_state.peering_network.outputs, "peering_subnet_id", null)
  tenant_one_vcn_cidr_block = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_vcn_cidr", null)
}

module routing_vnic_attachement2 {
  source = "../../../modules/routing_vnic_attachment"

  display_name              = "${module.routing_instance.instance2.hostname_label} peering interface"
  compartment_id            = local.compartment_id
  bastion_ip                = local.bastion_ip
  routing_ip                = module.routing_instance.instance2.private_ip
  routing_instance_id       = module.routing_instance.instance2.id
  hostname_label            = module.routing_instance.instance2.hostname_label
  peering_subnet_cidr       = lookup(data.terraform_remote_state.peering_network.outputs, "peering_subnet_cidr", null)
  peering_subnet_id         = lookup(data.terraform_remote_state.peering_network.outputs, "peering_subnet_id", null)
  tenant_one_vcn_cidr_block = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_vcn_cidr", null)
}

resource oci_core_private_ip floating_peering_ip  {
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