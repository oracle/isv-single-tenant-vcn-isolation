# Configure the main netowrk including VPC, Subnet, Seclist
module routing_vnic_attachement {
  source = "../../../modules/routing_vnic_attachment"

  compartment_id = 	"${data.terraform_remote_state.management_network.outputs.management_compartment_id}"
  
  bastion_ip	 		=	"${data.terraform_remote_state.management_servers.outputs.bastion_ip}"
  routing_ip			=	"${data.terraform_remote_state.management_servers.outputs.routing_ip}"
  routing_instance_id   = "${data.terraform_remote_state.management_servers.outputs.routing_id}"
  peering_subnet_cidr 	=	"${data.terraform_remote_state.peering_network.outputs.peering_subnet_cidr}"
  peering_subnet_id     = "${data.terraform_remote_state.peering_network.outputs.peering_subnet_id}"
  tenant_one_vcn_cidr_block	= "${data.terraform_remote_state.tenant_network.outputs.tenant_vcn_cidr}"
}


output routing_secondary_vnic_id {
	value = "${module.routing_vnic_attachement.routing_secondary_vnic_id}"
}