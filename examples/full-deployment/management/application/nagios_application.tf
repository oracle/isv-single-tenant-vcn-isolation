# Configure the main netowrk including VPC, Subnet, Seclist
module nagios_application {
  source = "../../../modules/nagios_application"

  compartment_id     = lookup(data.terraform_remote_state.management_network.outputs, "management_compartment_id", null)
  management_host_ip = lookup(data.terraform_remote_state.management_servers.outputs, "management_ip", null)
  bastion_host_ip    = lookup(data.terraform_remote_state.management_servers.outputs, "bastion_ip", null)
  tenant_host_ips    = join(",", list(lookup(data.terraform_remote_state.tenant_servers.outputs, "tenant_1_private_ip", ""),lookup(data.terraform_remote_state.tenant_servers.outputs, "tenant_2_private_ip", ""),lookup(data.terraform_remote_state.tenant_servers.outputs, "tenant_3_private_ip", ""), lookup(data.terraform_remote_state.tenant_servers.outputs, "tenant_4_private_ip", "")))
}

output "nagios_ran" {
  value = "OK"
}
