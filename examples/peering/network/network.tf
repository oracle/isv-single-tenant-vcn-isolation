# Configure the main netowrk including VPC, Subnet, Seclist
###
### Network for peering 1 ##########################################
module peering_1_network {
  source = "../../../modules/peering_network"

  compartment_id = module.peering_compartment.compartment_id
  vcn_name       = var.display_name_1
  dns_label      = var.display_name_1
  vcn_cidr_block = var.vcn_cidr_block_1

  peering_subnet_cidr   = var.vcn_cidr_block_1
  #TODO -- substitute hardcoded values with variable (manage dependency with tenant vcn creation)
  tenant_vcn_cidr_block = [ "10.1.0.0/16", "10.2.0.0/16" ]
}

output "peering_1_vcn_id" {
  value = module.peering_1_network.peering_vcn.id
}

output "peering_1_subnet_id" {
  value = module.peering_1_network.peering_subnet.id
}

output "peering_1_lpg_1_id" {
  value = module.peering_1_network.peering_gateway_1.id
}

output "peering_1_lpg_2_id" {
  value = module.peering_1_network.peering_gateway_2.id
}

output "peering_1_subnet_cidr" {
  value = module.peering_1_network.peering_subnet.cidr_block
}

###
### Network for peering 2 ##########################################
module peering_2_network {
  source = "../../../modules/peering_network"

  compartment_id = module.peering_compartment.compartment_id
  vcn_name       = var.display_name_2
  dns_label      = var.display_name_2
  vcn_cidr_block = var.vcn_cidr_block_2

  peering_subnet_cidr   = var.vcn_cidr_block_2
  #TODO -- substitute hardcoded values with variable (manage dependency with tenant vcn creation)
  tenant_vcn_cidr_block = [ "10.3.0.0/16", "10.4.0.0/16" ]
}

output "peering_2_vcn_id" {
  value = module.peering_2_network.peering_vcn.id
}

output "peering_2_subnet_id" {
  value = module.peering_2_network.peering_subnet.id
}

output "peering_2_lpg_1_id" {
  value = module.peering_2_network.peering_gateway_1.id
}

output "peering_2_lpg_2_id" {
  value = module.peering_2_network.peering_gateway_2.id
}

output "peering_2_subnet_cidr" {
  value = module.peering_2_network.peering_subnet.cidr_block
}