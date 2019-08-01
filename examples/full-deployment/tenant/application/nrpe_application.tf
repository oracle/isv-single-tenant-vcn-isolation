/*
 * Exampel deployment of the Nagios Core agent on each of the tenant instances
 */

# Tenant 1
module nrpe_application_1 {
  source = "../../../../modules/nrpe_application"

  tenant_ip        = data.terraform_remote_state.tenant_servers.outputs.tenant_1_private_ip
  nagios_server_ip = data.terraform_remote_state.mgmt_servers.outputs.management_ip
  bastion_host_ip  = data.terraform_remote_state.access.outputs.bastion_ip

  bastion_ssh_private_key_file = var.bastion_ssh_private_key_file
  remote_ssh_private_key_file  = var.remote_ssh_private_key_file
}

output "tenant_1_private_ip" {
  value = "nrpe_agent installed on tenant_1"
}

# Tenant 2
module nrpe_application_2 {
  source = "../../../../modules/nrpe_application"

  tenant_ip        = data.terraform_remote_state.tenant_servers.outputs.tenant_2_private_ip
  nagios_server_ip = data.terraform_remote_state.mgmt_servers.outputs.management_ip
  bastion_host_ip  = data.terraform_remote_state.access.outputs.bastion_ip

  bastion_ssh_private_key_file = var.bastion_ssh_private_key_file
  remote_ssh_private_key_file  = var.remote_ssh_private_key_file
}

output "tenant_2_private_ip" {
  value = "nrpe_agent installed on tenant_2"
}

# Tenant 3
module nrpe_application_3 {
  source = "../../../../modules/nrpe_application"

  tenant_ip        = data.terraform_remote_state.tenant_servers.outputs.tenant_3_private_ip
  nagios_server_ip = data.terraform_remote_state.mgmt_servers.outputs.management_ip
  bastion_host_ip  = data.terraform_remote_state.access.outputs.bastion_ip

  bastion_ssh_private_key_file = var.bastion_ssh_private_key_file
  remote_ssh_private_key_file  = var.remote_ssh_private_key_file
}

output "tenant_3_private_ip" {
  value = "nrpe_agent installed on tenant_3"
}


# Tenant 4
module nrpe_application_4 {
  source = "../../../../modules/nrpe_application"

  tenant_ip        = data.terraform_remote_state.tenant_servers.outputs.tenant_4_private_ip
  nagios_server_ip = data.terraform_remote_state.mgmt_servers.outputs.management_ip
  bastion_host_ip  = data.terraform_remote_state.access.outputs.bastion_ip

  bastion_ssh_private_key_file = var.bastion_ssh_private_key_file
  remote_ssh_private_key_file  = var.remote_ssh_private_key_file
}

output "tenant_4_private_ip" {
  value = "nrpe_agent installed on tenant_4"
}
