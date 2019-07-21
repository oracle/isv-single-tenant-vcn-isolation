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

data "terraform_remote_state" "access" {
  backend = "local"

  config = {
    path = "../state/management/access/terraform.tfstate"
  }
}


data "terraform_remote_state" "management_servers" {
  backend = "local"

  config = {
    path = "../state/management/servers/terraform.tfstate"
  }
}

data "terraform_remote_state" "tenant_servers" {
  backend = "local"

  config = {
    path = "../../tenant/state/tenant/servers/terraform.tfstate"
  }
}