terraform {
  required_version = ">= 0.12.0"

  backend "local" {
    path = "../state/management/access/terraform.tfstate"
  }
}

locals {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
}

