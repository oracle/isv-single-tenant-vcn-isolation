# Configure the main netowrk including VPC, Subnet, Seclist
module bastion_instance {
  source = "../../../modules/bastion_instance"

  compartment_id      = data.terraform_remote_state.management_network.outputs.management_compartment_id
  source_id           = data.oci_core_images.oraclelinux.images.0.id
  subnet_id           = data.terraform_remote_state.management_network.outputs.access_subnet_id
  availability_domain = local.availability_domain
}

output "bastion_ip" {
  value = module.bastion_instance.instance_ip
}