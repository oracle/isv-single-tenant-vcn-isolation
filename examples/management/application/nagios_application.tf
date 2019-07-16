# Configure the main netowrk including VPC, Subnet, Seclist
module nagios_application {
  source = "../../../modules/nagios_application"
  
  compartment_id 	= 	lookup(data.terraform_remote_state.management_network.outputs, "management_compartment_id", null)
  management_host_ip	=	lookup(data.terraform_remote_state.management_servers.outputs, "management_ip", null)
  bastion_host_ip	=	lookup(data.terraform_remote_state.management_servers.outputs, "bastion_ip", null)
  tenant_host_ip 	=	lookup(data.terraform_remote_state.tenant_servers.outputs, "tenant_private_ip", null)
}

output "nagios_ran" {
  value = "OK"
}