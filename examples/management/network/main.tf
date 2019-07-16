terraform {
  required_version = ">= 0.12.0"

  backend "local" {
    path = "../state/management/network/terraform.tfstate"
  }

}

