
module management_rte_attachement {
  source = "../../../modules/management_rte_attachement"

  compartment_id            = lookup(data.terraform_remote_state.management_network.outputs, "management_compartment_id", null)
  routing_ip                = lookup(data.terraform_remote_state.peering_servers.outputs, "routing_ip", null)
  peering_subnet_id         = lookup(data.terraform_remote_state.management_network.outputs, "peering_subnet_id", null)
  tenant_one_vcn_cidr_block = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_vcn_cidr", null)

  management_vcn_id    = lookup(data.terraform_remote_state.management_network.outputs, "management_vcn_id", null)
  management_subnet_id = lookup(data.terraform_remote_state.management_network.outputs, "management_subnet_id", null)
  management_nat_id    = lookup(data.terraform_remote_state.management_network.outputs, "management_nat_id", null)
  management_igw_id    = lookup(data.terraform_remote_state.management_network.outputs, "management_igw_id", null)
  access_subnet_id     = lookup(data.terraform_remote_state.management_network.outputs, "access_subnet_id", null)
}

output routing_id {
  value = module.management_rte_attachement.routing_id
}