
# Routing Instance 1
# HA ROUTING INSTANCE

module routing_instance_1_peering_1_routes {
  source = "../../../../modules/ip_route_add"

  vnic_id = module.routing_instance_1_peering_1_vnic_attachement.routing_secondary_vnic_id

  peering_subnet_cidr = data.terraform_remote_state.configuration.outputs.peering_vcns[0]
  tenant_vcn_cidrs    = data.terraform_remote_state.configuration.outputs.tenant_vcns_per_peering_vcn[0]

  bastion_host = local.bastion_ip
  ssh_host     = module.routing_instance_1.instance.private_ip
}

module routing_instance_1b_peering_1_routes {
  source = "../../../../modules/ip_route_add"

  vnic_id = module.routing_instance_1b_peering_1_vnic_attachement.routing_secondary_vnic_id

  peering_subnet_cidr = data.terraform_remote_state.configuration.outputs.peering_vcns[0]
  tenant_vcn_cidrs    = data.terraform_remote_state.configuration.outputs.tenant_vcns_per_peering_vcn[0]

  bastion_host = local.bastion_ip
  ssh_host     = module.routing_instance_1.instance_b.private_ip
}



# Routing Instance 2
# SINGLE ROUTING INSTANCE

module routing_instance_2_peering_1_routes {
  source = "../../../../modules/ip_route_add"

  vnic_id = module.routing_instance_2_peering_1_vnic_attachement.routing_secondary_vnic_id

  peering_subnet_cidr = data.terraform_remote_state.configuration.outputs.peering_vcns[1]
  tenant_vcn_cidrs    = data.terraform_remote_state.configuration.outputs.tenant_vcns_per_peering_vcn[1]

  bastion_host = local.bastion_ip
  ssh_host     = module.routing_instance_2.instance.private_ip
}

output ip_route_add_status {
  value = "IP Route Add successfull"
}