/*
 * Provision Nagios Core on the management instance
 */

module nagios_application {
  source = "../../../../modules/nagios_application"

  compartment_id     = data.terraform_remote_state.management_network.outputs.management_compartment_id
  management_host_ip = data.terraform_remote_state.management_servers.outputs.management_ip
  bastion_host_ip    = data.terraform_remote_state.access.outputs.bastion_ip
  tenant_host_ips    = join(",", list(data.terraform_remote_state.tenant_servers.outputs.tenant_1_private_ip, data.terraform_remote_state.tenant_servers.outputs.tenant_2_private_ip, data.terraform_remote_state.tenant_servers.outputs.tenant_3_private_ip, data.terraform_remote_state.tenant_servers.outputs.tenant_4_private_ip))
}

output "nagios_ran" {
  value = "OK"
}
