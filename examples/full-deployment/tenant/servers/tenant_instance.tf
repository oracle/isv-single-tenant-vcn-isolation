/*
 * Create the tenant server instances
 */

# Tenant 1
module tenant_instance_1 {
  source = "../../../../modules/tenant_instance"

  compartment_id      = data.terraform_remote_state.tenant_network.outputs.tenant_1_compartment_id
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = data.terraform_remote_state.tenant_network.outputs.tenant_1_private_subnet_id
  availability_domain = local.availability_domain
  bastion_ip          = data.terraform_remote_state.access.outputs.bastion_ip
}

output "tenant_1_private_ip" {
  value = module.tenant_instance_1.instance_ip
}

# Tenant 2
module tenant_instance_2 {
  source = "../../../../modules/tenant_instance"

  compartment_id      = data.terraform_remote_state.tenant_network.outputs.tenant_2_compartment_id
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = data.terraform_remote_state.tenant_network.outputs.tenant_2_private_subnet_id
  availability_domain = local.availability_domain
  bastion_ip          = data.terraform_remote_state.access.outputs.bastion_ip
}

output "tenant_2_private_ip" {
  value = module.tenant_instance_2.instance_ip
}

# Tenant 3
module tenant_instance_3 {
  source = "../../../../modules/tenant_instance"

  compartment_id      = data.terraform_remote_state.tenant_network.outputs.tenant_3_compartment_id
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = data.terraform_remote_state.tenant_network.outputs.tenant_3_private_subnet_id
  availability_domain = local.availability_domain
  bastion_ip          = data.terraform_remote_state.access.outputs.bastion_ip
}

output "tenant_3_private_ip" {
  value = module.tenant_instance_3.instance_ip
}


# Tenant 4
module tenant_instance_4 {
  source = "../../../../modules/tenant_instance"

  compartment_id      = data.terraform_remote_state.tenant_network.outputs.tenant_4_compartment_id
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = data.terraform_remote_state.tenant_network.outputs.tenant_4_private_subnet_id
  availability_domain = local.availability_domain
  bastion_ip          = data.terraform_remote_state.access.outputs.bastion_ip
}

output "tenant_4_private_ip" {
  value = module.tenant_instance_4.instance_ip
}
