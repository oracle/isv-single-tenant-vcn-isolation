# Configure the main netowrk including VPC, Subnet, Seclist
module management_rte_attachement {
  source = "../../../modules/management_rte_attachement"

  compartment_id = 	"${data.terraform_remote_state.management_network.outputs.management_compartment_id}"
  routing_ip			=	"${data.terraform_remote_state.management_servers.outputs.routing_ip}"
  peering_subnet_id     =	"${data.terraform_remote_state.management_network.outputs.peering_subnet_id}"
  tenant_one_vcn_cidr_block	= "${data.terraform_remote_state.tenant_network.outputs.tenant_vcn_cidr}"

  management_vcn_id 	=	"${data.terraform_remote_state.management_network.outputs.management_vcn_id}"
  management_subnet_id	=	"${data.terraform_remote_state.management_network.outputs.management_subnet_id}"
  management_nat_id     =	"${data.terraform_remote_state.management_network.outputs.management_nat_id}"
}

output routing_id {
	value = "${module.management_rte_attachement.routing_id}"
}