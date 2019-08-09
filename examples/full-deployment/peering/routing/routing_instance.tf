// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

/*
 * Create the routing instances to route throught peering networks
 */

# Routing Instance 1
# HA ROUTING INSTANCE
module routing_instance_1 {
  source = "../../../../modules/routing_instance_ha"

  hostname_label = "gateway1"
  display_name   = "gateway1"

  compartment_id            = local.compartment_id
  source_id                 = data.oci_core_images.oraclelinux.images.0.id
  subnet_id                 = data.terraform_remote_state.management_network.outputs.peering_subnet_id
  availability_domain       = local.availability_domain
  bastion_ip                = local.bastion_ip
  routing_security_group_id = data.terraform_remote_state.management_network.outputs.peering_security_group_id

  tenancy_id = var.tenancy_ocid
  region     = var.region

  bastion_ssh_private_key_file = var.bastion_ssh_private_key_file
  remote_ssh_public_key_file   = var.remote_ssh_public_key_file
  remote_ssh_private_key_file  = var.remote_ssh_private_key_file

  shape = "VM.Standard2.1" # TODO

  hacluster_password = var.hacluster_password
}

output "routing_instance_1_ip" {
  value = module.routing_instance_1.routing_ip.ip_address
}

output "routing_instance_1_ip_id" {
  value = module.routing_instance_1.routing_ip.id
}


# Routing Instance 2
# SINGLE ROUTING INSTANCE
module routing_instance_2 {
  source = "../../../../modules/routing_instance"

  hostname_label = "gateway2"
  display_name   = "gateway2"

  compartment_id                 = local.compartment_id
  source_id                      = data.oci_core_images.oraclelinux.images.0.id
  subnet_id                      = data.terraform_remote_state.management_network.outputs.peering_subnet_id
  availability_domain            = local.availability_domain
  bastion_ip                     = local.bastion_ip
  peering_security_group_id_list = [data.terraform_remote_state.management_network.outputs.peering_security_group_id]

  shape                        = "VM.Standard2.1" # TODO
  bastion_ssh_private_key_file = var.bastion_ssh_private_key_file
  remote_ssh_public_key_file   = var.remote_ssh_public_key_file
  remote_ssh_private_key_file  = var.remote_ssh_private_key_file
}

output "routing_instance_2_ip" {
  value = module.routing_instance_2.routing_ip.ip_address
}

output "routing_instance_2_ip_id" {
  value = module.routing_instance_2.routing_ip.id
}
