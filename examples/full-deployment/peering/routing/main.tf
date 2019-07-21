terraform {
  required_version = ">= 0.12.0"

  backend "local" {
    path = "../state/peering/routing/terraform.tfstate"
  }
}

locals {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")

  compartment_id = lookup(data.terraform_remote_state.peering_network.outputs, "peering_compartment_id", null)

  bastion_ip = lookup(data.terraform_remote_state.access.outputs, "bastion_ip", null)
} 