terraform {
  required_version = ">= 0.12.0"

  backend "local" {
    path = "../state/common/configuration/terraform.tfstate"
  }

}

