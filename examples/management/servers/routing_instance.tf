# Configure the main netowrk including VPC, Subnet, Seclist
module routing_instance {
  source = "../../../modules/routing_instance"

  compartment_id = 	"${data.terraform_remote_state.management_network.outputs.management_compartment_id}"
  source_id		 = 	"${data.oci_core_images.oraclelinux.images.0.id}"
  subnet_id		 =	"${data.terraform_remote_state.management_network.outputs.peering_subnet_id}"
  availability_domain	=	local.availability_domain
  bastion_ip	 =	"${module.bastion_instance.instance_ip}"
}


output "routing_ip" {
  value = "${module.routing_instance.instance_ip}"
}