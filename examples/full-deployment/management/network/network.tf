/*
 * Configure the management network
 */

module management_network {
  source = "../../../../modules/management_network"

  compartment_id         = module.management_compartment.compartment_id
  vcn_name               = "isv management"
  dns_label              = "isv"
  vcn_cidr_block         = var.vcn_cidr_block
  management_subnet_cidr = var.management_subnet_cidr
  access_subnet_cidr     = var.access_subnet_cidr
  peering_subnet_cidr    = var.peering_subnet_cidr
}

output "management_vcn_id" {
  value = module.management_network.vcn.id
}

output "management_subnet_id" {
  value = module.management_network.management_subnet.id
}

output "management_nat_id" {
  value = module.management_network.nat_id
}

output "management_igw_id" {
  value = module.management_network.igw_id
}

output "access_subnet_id" {
  value = module.management_network.access_subnet.id
}

output "peering_subnet_id" {
  value = module.management_network.peering_subnet.id
}

output "peering_subnet_cidr" {
  value = module.management_network.peering_subnet.cidr_block
}

output "management_subnet_cidr" {
  value = module.management_network.management_subnet.cidr_block
}