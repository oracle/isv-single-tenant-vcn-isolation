# Configure the main netowrk including VPC, Subnet, Seclist
module management_network {
  source = "../../../modules/management_network"

  compartment_id         = "${module.management_compartment.compartment_id}"
  vcn_name               = "isv management"
  dns_label              = "isv"
  vcn_cidr_block         = "10.254.0.0/16"
  management_subnet_cidr = "10.254.100.0/24"
  access_subnet_cidr     = "10.254.99.0/24"
  peering_subnet_cidr    = "10.254.254.0/24"
}

output "management_vcn_id" {
  value = "${module.management_network.vcn.id}"
}

output "management_subnet_id" {
  value = "${module.management_network.management_subnet.id}"
}

output "management_nat_id" {
  value = "${module.management_network.nat_id}"
}

output "management_igw_id" {
  value = "${module.management_network.igw_id}"
}

output "access_subnet_id" {
  value = "${module.management_network.access_subnet.id}"
}

output "peering_subnet_id" {
  value = "${module.management_network.peering_subnet.id}"
}

output "peering_subnet_cidr" {
  value = "${module.management_network.peering_subnet.cidr_block}"
}

output "management_subnet_cidr" {
  value = "${module.management_network.management_subnet.cidr_block}"
}