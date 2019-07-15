terraform {
  required_version = ">= 0.12.0"
  
  backend "local" {
    path = "../state/tenant/servers/terraform.tfstate"
  }
}

data "terraform_remote_state" "tenant_network" {
  backend = "local"

  config = {
    path = "../state/tenant/network/terraform.tfstate"
  }
}

data "terraform_remote_state" "mgmt_servers" {
  backend = "local"

  config = {
    path = "../../management/state/management/servers/terraform.tfstate"
  }
}