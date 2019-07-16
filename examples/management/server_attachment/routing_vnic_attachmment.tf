# Configure the main netowrk including VPC, Subnet, Seclist
module routing_vnic_attachement {
  source = "../../../modules/routing_vnic_attachment"

  compartment_id = 	lookup(data.terraform_remote_state.management_network.outputs, "management_compartment_id", null)
  
  bastion_ip	 		=	lookup(data.terraform_remote_state.management_servers.outputs, "bastion_ip", null)
  routing_ip			=	lookup(data.terraform_remote_state.management_servers.outputs, "routing_ip", null)
  routing_instance_id   = lookup(data.terraform_remote_state.management_servers.outputs, "routing_id", null)
  peering_subnet_cidr 	=	lookup(data.terraform_remote_state.peering_network.outputs, "peering_subnet_cidr", null)
  peering_subnet_id     = lookup(data.terraform_remote_state.peering_network.outputs, "peering_subnet_id", null)
  tenant_one_vcn_cidr_block	= lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_vcn_cidr", null)
}


output routing_secondary_vnic_id {
	value = "${module.routing_vnic_attachement.routing_secondary_vnic_id}"
}