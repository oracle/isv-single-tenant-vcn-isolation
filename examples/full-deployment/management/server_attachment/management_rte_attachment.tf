
module management_rte_attachement {
  source = "../../../../modules/management_rte_attachement"

  compartment_id            = lookup(data.terraform_remote_state.management_network.outputs, "management_compartment_id", null)

  routing_ip_ids               = [
    lookup(data.terraform_remote_state.peering_servers.outputs, "routing_instance_1_ip_id", null),
    lookup(data.terraform_remote_state.peering_servers.outputs, "routing_instance_2_ip_id", null),
  ]

  tenant_vcn_cidr_blocks = lookup(data.terraform_remote_state.configuration.outputs, "tenant_vcns", null)

  management_vcn_id    = lookup(data.terraform_remote_state.management_network.outputs, "management_vcn_id", null)
  management_subnet_id = lookup(data.terraform_remote_state.management_network.outputs, "management_subnet_id", null)
  management_nat_id    = lookup(data.terraform_remote_state.management_network.outputs, "management_nat_id", null)
  management_igw_id    = lookup(data.terraform_remote_state.management_network.outputs, "management_igw_id", null)
  access_subnet_id     = lookup(data.terraform_remote_state.management_network.outputs, "access_subnet_id", null)
}

output routing_id {
  value = module.management_rte_attachement.routing_id
}