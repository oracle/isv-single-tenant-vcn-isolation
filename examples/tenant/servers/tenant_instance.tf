# Configure the main netowrk including VPC, Subnet, Seclist
######### tenant 1 instance provisioning
###
module tenant_instance_1 {
  source = "../../../modules/tenant_instance"

  providers = {
    oci.home = "oci.home"
  }

  compartment_id      = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_1_compartment_id", null)
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_1_private_subnet_id", null)
  tenant_private_ip   = "${cidrhost(lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_1_private_subnet_cidr", null), 2)}"
  availability_domain = local.availability_domain
  bastion_ip          = lookup(data.terraform_remote_state.mgmt_servers.outputs, "bastion_ip", null)
}

output "tenant_1_private_ip" {
  value = module.tenant_instance_1.instance_ip
}

######### tenant 2 instance provisioning
#
module tenant_instance_2 {
  source = "../../../modules/tenant_instance"

  providers = {
    oci.home = "oci.home"
  }

  compartment_id      = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_2_compartment_id", null)
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_2_private_subnet_id", null)
  tenant_private_ip   = "${cidrhost(lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_2_private_subnet_cidr", null), 2)}"
  availability_domain = local.availability_domain
  bastion_ip          = lookup(data.terraform_remote_state.mgmt_servers.outputs, "bastion_ip", null)
}

output "tenant_2_private_ip" {
  value = module.tenant_instance_2.instance_ip
}


######### tenant 3 instance provisioning
#
module tenant_instance_3 {
  source = "../../../modules/tenant_instance"

  providers = {
    oci.home = "oci.home"
  }

  compartment_id      = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_3_compartment_id", null)
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_3_private_subnet_id", null)
  tenant_private_ip   = "${cidrhost(lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_3_private_subnet_cidr", null), 2)}"
  availability_domain = local.availability_domain
  bastion_ip          = lookup(data.terraform_remote_state.mgmt_servers.outputs, "bastion_ip", null)
}

output "tenant_3_private_ip" {
  value = module.tenant_instance_3.instance_ip
}


######### tenant 4 instance provisioning
#
module tenant_instance_4 {
  source = "../../../modules/tenant_instance"

  providers = {
    oci.home = "oci.home"
  }

  compartment_id      = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_4_compartment_id", null)
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_4_private_subnet_id", null)
  tenant_private_ip   = "${cidrhost(lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_4_private_subnet_cidr", null), 2)}"
  availability_domain = local.availability_domain
  bastion_ip          = lookup(data.terraform_remote_state.mgmt_servers.outputs, "bastion_ip", null)
}

output "tenant_4_private_ip" {
  value = module.tenant_instance_4.instance_ip
}