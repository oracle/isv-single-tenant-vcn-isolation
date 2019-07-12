terraform {
  required_version = ">= 0.12.0"

  
  backend "local" {
    path = "../state/tenant/network/terraform.tfstate"
  }
}


data "terraform_remote_state" "peering_network" {
  backend = "local"

  config = {
    path = "../../peering/state/peering/network/terraform.tfstate"
  }
}


data "terraform_remote_state" "mgmt_network" {
  backend = "local"

  config = {
    path = "../../management/state/management/network/terraform.tfstate"
  }
}