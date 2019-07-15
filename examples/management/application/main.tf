terraform {
  required_version = ">= 0.12.0"

  backend "local" {
    path = "../state/management/application/terraform.tfstate"
  }

}

data "terraform_remote_state" "management_network" {
  backend = "local"

  config = {
    path = "../state/management/network/terraform.tfstate"
  }
}