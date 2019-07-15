terraform {
  required_version = ">= 0.12.0"

  backend "local" {
    path = "../state/management/server_attachment/terraform.tfstate"
  }
}

locals {
  region_map = {
    for r in data.oci_identity_regions.regions.regions:
    r.key => r.name
  }

  home_region             = lookup(local.region_map, data.oci_identity_tenancy.tenancy.home_region_key)
  availability_domain     = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")

  root_compartment_id = var.compartment_ocid
}

data "terraform_remote_state" "management_network" {
  backend = "local"

  config = {
    path = "../state/management/network/terraform.tfstate"
  }
}

data "terraform_remote_state" "tenant_network" {
  backend = "local"

  config = {
    path = "../../tenant/state/tenant/network/terraform.tfstate"
  }
}

data "terraform_remote_state" "peering_network" {
  backend = "local"

  config = {
    path = "../../peering/state/peering/network/terraform.tfstate"
  }
}

data "terraform_remote_state" "management_servers" {
  backend = "local"

  config = {
    path = "../state/management/servers/terraform.tfstate"
  }
}