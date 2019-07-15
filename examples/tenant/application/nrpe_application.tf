# Configure the main netowrk including VPC, Subnet, Seclist
module nrpe_application {
  source = "../../../modules/nrpe_application"
  
  compartment_id = 	"${data.terraform_remote_state.tenant_network.outputs.tenant_compartment_id}"
  source_id		 = 	"${data.oci_core_images.oraclelinux.images.0.id}"
  subnet_id		 =	"${data.terraform_remote_state.tenant_network.outputs.tenant_private_subnet_id}"
  tenant_ip 	 =	"${data.terraform_remote_state.tenant_servers.outputs.tenant_private_ip}"
  nagios_server_ip		=	"${data.terraform_remote_state.mgmt_servers.outputs.management_ip}"
  bastion_host_ip		=	"${data.terraform_remote_state.mgmt_servers.outputs.bastion_ip}"
  availability_domain	=	local.availability_domain

}

output "nrpe_ran" {
  value = "OK"
}