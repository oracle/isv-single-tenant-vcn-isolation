# Configure the main netowrk including VPC, Subnet, Seclist
###
### Network for tenant 1 ##########################################
module tenant_1_network {
  source = "../../../../modules/tenant_network"

  compartment_id = module.tenant_1_compartment.compartment_id
  vcn_name       = var.display_name_1
  dns_label      = var.display_name_1
  vcn_cidr_block = var.vcn_cidr_block_1

  tenant_public_subnet_cidr  = "${cidrsubnet(var.vcn_cidr_block_1, 8, 0)}"
  tenant_private_subnet_cidr = "${cidrsubnet(var.vcn_cidr_block_1, 8, 1)}"

  tenant_peering_subnet_cidr     = (length(data.terraform_remote_state.configuration.outputs) == 0 ? null : data.terraform_remote_state.configuration.outputs.peering_vcns[0])
  management_peering_subnet_cidr = data.terraform_remote_state.mgmt_network.outputs.management_subnet_cidr

  # TODO calculate index 
  peering_lpg_id = (length(data.terraform_remote_state.peering_network.outputs) == 0 ? null :  data.terraform_remote_state.peering_network.outputs.peering_1_network.peering_gateway_ids[0])
}

output "tenant_1_vcn_id" {
  value = module.tenant_1_network.tenant_vcn.id
}

output "tenant_1_private_subnet_id" {
  value = module.tenant_1_network.tenant_private_subnet.id
}

output "tenant_1_vcn_cidr" {
  value = module.tenant_1_network.tenant_vcn.cidr_block
}

output "tenant_1_private_subnet_cidr" {
  value = module.tenant_1_network.tenant_private_subnet.cidr_block
}

###
### Network for tenant 2 ##########################################
module tenant_2_network {
  source = "../../../../modules/tenant_network"

  compartment_id = module.tenant_2_compartment.compartment_id
  vcn_name       = var.display_name_2
  dns_label      = var.display_name_2
  vcn_cidr_block = var.vcn_cidr_block_2

  tenant_public_subnet_cidr  = "${cidrsubnet(var.vcn_cidr_block_2, 8, 0)}"
  tenant_private_subnet_cidr = "${cidrsubnet(var.vcn_cidr_block_2, 8, 1)}"

  tenant_peering_subnet_cidr     = (length(data.terraform_remote_state.configuration.outputs) == 0 ? null : data.terraform_remote_state.configuration.outputs.peering_vcns[0])
  management_peering_subnet_cidr = data.terraform_remote_state.mgmt_network.outputs.management_subnet_cidr

  # TODO calculate index 
  peering_lpg_id = (length(data.terraform_remote_state.peering_network.outputs) == 0 ? null : data.terraform_remote_state.peering_network.outputs.peering_1_network.peering_gateway_ids[1])
}

output "tenant_2_vcn_id" {
  value = module.tenant_2_network.tenant_vcn.id
}

output "tenant_2_private_subnet_id" {
  value = module.tenant_2_network.tenant_private_subnet.id
}

output "tenant_2_vcn_cidr" {
  value = module.tenant_2_network.tenant_vcn.cidr_block
}

output "tenant_2_private_subnet_cidr" {
  value = module.tenant_2_network.tenant_private_subnet.cidr_block
}

###
### Network for tenant 3 ##########################################
module tenant_3_network {
  source = "../../../../modules/tenant_network"

  compartment_id = module.tenant_3_compartment.compartment_id
  vcn_name       = var.display_name_3
  dns_label      = var.display_name_3
  vcn_cidr_block = var.vcn_cidr_block_3

  tenant_public_subnet_cidr  = "${cidrsubnet(var.vcn_cidr_block_3, 8, 0)}"
  tenant_private_subnet_cidr = "${cidrsubnet(var.vcn_cidr_block_3, 8, 1)}"

  tenant_peering_subnet_cidr     = (length(data.terraform_remote_state.configuration.outputs) == 0 ? null : data.terraform_remote_state.configuration.outputs.peering_vcns[1])
  management_peering_subnet_cidr = data.terraform_remote_state.mgmt_network.outputs.management_subnet_cidr

  # TODO calculate index 
  peering_lpg_id = (length(data.terraform_remote_state.peering_network.outputs) == 0 ? null : data.terraform_remote_state.peering_network.outputs.peering_2_network.peering_gateway_ids[0])
}

output "tenant_3_vcn_id" {
  value = module.tenant_3_network.tenant_vcn.id
}

output "tenant_3_private_subnet_id" {
  value = module.tenant_3_network.tenant_private_subnet.id
}

output "tenant_3_vcn_cidr" {
  value = module.tenant_3_network.tenant_vcn.cidr_block
}

output "tenant_3_private_subnet_cidr" {
  value = module.tenant_3_network.tenant_private_subnet.cidr_block
}

###
### Network for tenant 4 ##########################################
module tenant_4_network {
  source = "../../../../modules/tenant_network"

  compartment_id = module.tenant_4_compartment.compartment_id
  vcn_name       = var.display_name_4
  dns_label      = var.display_name_4
  vcn_cidr_block = var.vcn_cidr_block_4

  tenant_public_subnet_cidr  = "${cidrsubnet(var.vcn_cidr_block_4, 8, 0)}"
  tenant_private_subnet_cidr = "${cidrsubnet(var.vcn_cidr_block_4, 8, 1)}"

  tenant_peering_subnet_cidr     = (length(data.terraform_remote_state.configuration.outputs) == 0 ? null : data.terraform_remote_state.configuration.outputs.peering_vcns[1])
  management_peering_subnet_cidr = data.terraform_remote_state.mgmt_network.outputs.management_subnet_cidr

  # TODO calculate index 
  peering_lpg_id = (length(data.terraform_remote_state.peering_network.outputs) == 0 ? null : data.terraform_remote_state.peering_network.outputs.peering_2_network.peering_gateway_ids[1])
}

output "tenant_4_vcn_id" {
  value = module.tenant_4_network.tenant_vcn.id
}

output "tenant_4_private_subnet_id" {
  value = module.tenant_4_network.tenant_private_subnet.id
}

output "tenant_4_vcn_cidr" {
  value = module.tenant_4_network.tenant_vcn.cidr_block
}

output "tenant_4_private_subnet_cidr" {
  value = module.tenant_4_network.tenant_private_subnet.cidr_block
}