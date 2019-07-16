# Configure the main netowrk including VPC, Subnet, Seclist
module lb_nagios {
  source = "../../../modules/lb_nagios"

  compartment_id = 	"${data.terraform_remote_state.management_network.outputs.management_compartment_id}"
  subnet_id		 =	"${data.terraform_remote_state.management_network.outputs.access_subnet_id}"
  availability_domain	=	local.availability_domain
  management_private_ip	=	"${module.management_instance.instance_ip}"
}

output "lb_ip" {
  value = "${module.lb_nagios.lb_public_ip}"
}