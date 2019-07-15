# Configure the main netowrk including VPC, Subnet, Seclist
module management_instance {
  source = "../../../modules/management_instance"

  compartment_id = 	"${data.terraform_remote_state.management_network.outputs.management_compartment_id}"
  source_id		 = 	"${data.oci_core_images.oraclelinux.images.0.id}"
  subnet_id		 =	"${data.terraform_remote_state.management_network.outputs.management_subnet_id}"
  availability_domain	=	local.availability_domain
  bastion_ip	 =	"${module.bastion_instance.instance_ip}"
}


output "management_ip" {
  value = "${module.management_instance.instance_ip}"
}