
module routing_instance {
  source = "../../../modules/routing_instance_ha"

  hostname_label = "gateway"
  display_name   = "gateway"

  compartment_id      = local.compartment_id
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = data.terraform_remote_state.management_network.outputs.peering_subnet_id
  availability_domain = local.availability_domain
  bastion_ip          = local.bastion_ip
}

output "routing_ip" {
  value = module.routing_instance.floating_ip
}

output "routing_id" {
  value = module.routing_instance.instance_ids
}