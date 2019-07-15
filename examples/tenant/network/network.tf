# Configure the main netowrk including VPC, Subnet, Seclist
module tenant_network {
  source = "../../../modules/tenant_network"

  compartment_id		= "${module.tenant_compartment.compartment_id}"
  vcn_name				  = "tenant1"		
  dns_label				  = "tenant1"
  vcn_cidr_block		= "192.168.0.0/16"

  tenant_public_subnet_cidr  = "192.168.1.0/24"
  tenant_private_subnet_cidr = "192.168.2.0/24"

  tenant_peering_subnet_cidr = "${data.terraform_remote_state.peering_network.outputs.peering_subnet_cidr}"
  management_peering_subnet_cidr  = "${data.terraform_remote_state.mgmt_network.outputs.management_subnet_cidr}"

  peering_lpg_id    = data.terraform_remote_state.peering_network.outputs.peering_lpg_id
}

output "tenant_vcn_id" {
  value = "${module.tenant_network.tenant_vcn.id}"
}

output "tenant_private_subnet_id" {
	value = "${module.tenant_network.tenant_subnet.id}"
}

output "tenant_vcn_cidr" {
  value = "${module.tenant_network.tenant_vcn.cidr_block}"
}