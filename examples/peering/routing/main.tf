terraform {
  required_version = ">= 0.12.0"

  backend "local" {
    path = "../state/peering/routing/terraform.tfstate"
  }
}

data "terraform_remote_state" "management_network" {
  backend = "local"

  config = {
    path = "../../management/state/management/network/terraform.tfstate"
  }
}

data "terraform_remote_state" "access" {
  backend = "local"

  config = {
    path = "../../management/state/management/access/terraform.tfstate"
  }
}

locals {
  bastion_ip = lookup(data.terraform_remote_state.access.outputs, "bastion_ip", null)
}