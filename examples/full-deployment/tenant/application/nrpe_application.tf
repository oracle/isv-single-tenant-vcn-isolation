# Configure the main netowrk including VPC, Subnet, Seclist
####### nrpe deployment for tenant 1 #############
###
module nrpe_application_1 {
  source = "../../../../modules/nrpe_application"

  compartment_id      = data.terraform_remote_state.tenant_network.outputs.tenant_1_compartment_id
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = data.terraform_remote_state.tenant_network.outputs.tenant_1_private_subnet_id
  tenant_ip           = data.terraform_remote_state.tenant_servers.outputs.tenant_1_private_ip
  nagios_server_ip    = data.terraform_remote_state.mgmt_servers.outputs.management_ip
  bastion_host_ip     = data.terraform_remote_state.access.outputs.bastion_ip
  availability_domain = local.availability_domain

}

output "tenant_1_private_ip" {
  value = "nrpe_agent installed on tenant_1"
}

####### nrpe deployment for tenant 2 #############
###
module nrpe_application_2 {
  source = "../../../../modules/nrpe_application"

  compartment_id      = data.terraform_remote_state.tenant_network.outputs.tenant_2_compartment_id
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = data.terraform_remote_state.tenant_network.outputs.tenant_2_private_subnet_id
  tenant_ip           = data.terraform_remote_state.tenant_servers.outputs.tenant_2_private_ip
  nagios_server_ip    = data.terraform_remote_state.mgmt_servers.outputs.management_ip
  bastion_host_ip     = data.terraform_remote_state.access.outputs.bastion_ip
  availability_domain = local.availability_domain

}

output "tenant_2_private_ip" {
  value = "nrpe_agent installed on tenant_2"
}

####### nrpe deployment for tenant 3 #############
###
module nrpe_application_3 {
  source = "../../../../modules/nrpe_application"

  compartment_id      = data.terraform_remote_state.tenant_network.outputs.tenant_3_compartment_id
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = data.terraform_remote_state.tenant_network.outputs.tenant_3_private_subnet_id
  tenant_ip           = data.terraform_remote_state.tenant_servers.outputs.tenant_3_private_ip
  nagios_server_ip    = data.terraform_remote_state.mgmt_servers.outputs.management_ip
  bastion_host_ip     = data.terraform_remote_state.access.outputs.bastion_ip
  availability_domain = local.availability_domain

}

output "tenant_3_private_ip" {
  value = "nrpe_agent installed on tenant_3"
}


####### nrpe deployment for tenant 4 #############
###
module nrpe_application_4 {
  source = "../../../../modules/nrpe_application"

  compartment_id      = data.terraform_remote_state.tenant_network.outputs.tenant_4_compartment_id
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = data.terraform_remote_state.tenant_network.outputs.tenant_4_private_subnet_id
  tenant_ip           = data.terraform_remote_state.tenant_servers.outputs.tenant_4_private_ip
  nagios_server_ip    = data.terraform_remote_state.mgmt_servers.outputs.management_ip
  bastion_host_ip     = data.terraform_remote_state.access.outputs.bastion_ip
  availability_domain = local.availability_domain

}

output "tenant_4_private_ip" {
  value = "nrpe_agent installed on tenant_4"
}
