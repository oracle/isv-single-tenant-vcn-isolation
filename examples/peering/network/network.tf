# Configure the main netowrk including VPC, Subnet, Seclist
module peering_network {
  source = "../../../modules/peering_network"

  providers = {
    oci.home = "oci.home"
  }
  
  compartment_id		= "${module.peering_compartment.compartment_id}"
  vcn_name				  = "peering"		
  dns_label				  = "peering"
  vcn_cidr_block		= "10.253.0.0/30"

  peering_subnet_cidr   = "10.253.0.0/30"
  tenant_vcn_cidr_block = "10.1.0.0/16" # TODO get from var
}

output "peering_vcn_id" {
  value = "${module.peering_network.peering_vcn.id}"
}

output "peering_subnet_id" {
	value = "${module.peering_network.peering_subnet.id}"
}

output "peering_lpg_id" {
  value = "${module.peering_network.peering_gateway.id}"
}

output "peering_subnet_cidr" {
  value = "${module.peering_network.peering_subnet.cidr_block}"
}