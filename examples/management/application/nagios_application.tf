# Configure the main netowrk including VPC, Subnet, Seclist
module nagios_application {
  source = "../../../modules/nagios_application"
  
  compartment_id 	= 	"${data.terraform_remote_state.management_network.outputs.management_compartment_id}"
  management_host_ip	=	"${data.terraform_remote_state.management_servers.outputs.management_ip}"
  bastion_host_ip	=	"${data.terraform_remote_state.management_servers.outputs.bastion_ip}"
  tenant_host_ip 	=	"${data.terraform_remote_state.tenant_servers.outputs.tenant_private_ip}"
}

output "nagios_ran" {
  value = "OK"
}