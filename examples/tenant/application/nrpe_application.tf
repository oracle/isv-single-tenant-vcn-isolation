# Configure the main netowrk including VPC, Subnet, Seclist
module nrpe_application {
  source = "../../../modules/nrpe_application"

  compartment_id      = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_compartment_id", null)
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_private_subnet_id", null)
  tenant_ip           = lookup(data.terraform_remote_state.tenant_servers.outputs, "tenant_private_ip", null)
  nagios_server_ip    = lookup(data.terraform_remote_state.mgmt_servers.outputs, "management_ip", null)
  bastion_host_ip     = lookup(data.terraform_remote_state.access.outputs, "bastion_ip", null)
  availability_domain = local.availability_domain

}

output "nrpe_ran" {
  value = "OK"
}