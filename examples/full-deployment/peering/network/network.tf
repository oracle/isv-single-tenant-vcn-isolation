
# TODO dynamically create required number of peering networks

###
### Network for peering 1 ##########################################
module peering_1_network {
  source = "../../../../modules/peering_network"

  compartment_id = module.peering_compartment.compartment_id
  vcn_name  = "peering01"
  dns_label = "peering01"

  vcn_cidr_block         = data.terraform_remote_state.configuration.outputs.peering_vcns[0]
  peering_subnet_cidr    = data.terraform_remote_state.configuration.outputs.peering_vcns[0]
  tenant_vcn_cidr_blocks = data.terraform_remote_state.configuration.outputs.tenant_vcns_per_peering_vcn[0]
}

output "peering_1_vcn_id" {
  value = module.peering_1_network.peering_vcn.id
}

output "peering_1_subnet_id" {
  value = module.peering_1_network.peering_subnet.id
}

output "peering_1_lpg_1_id" {
  value = module.peering_1_network.peering_gateway_ids[0]
}

output "peering_1_lpg_2_id" {
  value = module.peering_1_network.peering_gateway_ids[1]
}

output "peering_1_subnet_cidr" {
  value = module.peering_1_network.peering_subnet.cidr_block
}

###
### Network for peering 2 ##########################################
module peering_2_network {
  source = "../../../../modules/peering_network"

  compartment_id = module.peering_compartment.compartment_id
  vcn_name  = "peering02"
  dns_label = "peering02"

  vcn_cidr_block         = data.terraform_remote_state.configuration.outputs.peering_vcns[1]
  peering_subnet_cidr    = data.terraform_remote_state.configuration.outputs.peering_vcns[1]
  tenant_vcn_cidr_blocks = data.terraform_remote_state.configuration.outputs.tenant_vcns_per_peering_vcn[1]
}

output "peering_2_vcn_id" {
  value = module.peering_2_network.peering_vcn.id
}

output "peering_2_subnet_id" {
  value = module.peering_2_network.peering_subnet.id
}

output "peering_2_lpg_1_id" {
  value = module.peering_2_network.peering_gateway_ids[0]
}

output "peering_2_lpg_2_id" {
  value = module.peering_2_network.peering_gateway_ids[1]
}

output "peering_2_subnet_cidr" {
  value = module.peering_2_network.peering_subnet.cidr_block
}