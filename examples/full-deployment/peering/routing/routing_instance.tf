
# Routing Instance 1
# HA ROUTING INSTANCE

module routing_instance_1 {
  source = "../../../../modules/routing_instance_ha"

  hostname_label = "gateway1"
  display_name   = "gateway1"

  compartment_id      = local.compartment_id
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = data.terraform_remote_state.management_network.outputs.peering_subnet_id
  availability_domain = local.availability_domain
  bastion_ip          = local.bastion_ip

  tenancy_id = var.tenancy_ocid
  region     = var.region

  shape = "VM.Standard2.1" # TODO
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

  compartment_id      = local.compartment_id
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = data.terraform_remote_state.management_network.outputs.peering_subnet_id
  availability_domain = local.availability_domain
  bastion_ip          = local.bastion_ip

  tenancy_id = var.tenancy_ocid
  region     = var.region

  shape = "VM.Standard2.1"  # TODO
}

output "routing_instance_2_ip" {
  value = module.routing_instance_2.routing_ip.ip_address
}

output "routing_instance_2_ip_id" {
  value = module.routing_instance_2.routing_ip.id
}
