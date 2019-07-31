# COMMON DATA SOURCES

data oci_identity_tenancy tenancy {
  tenancy_id = var.tenancy_ocid
}

data oci_identity_regions regions {
}

# Availability Domains
data oci_identity_availability_domains ADs {
  compartment_id = var.tenancy_ocid
}

# Oracle Linux VM Image
data oci_core_images oraclelinux {
  compartment_id = var.compartment_ocid

  operating_system         = "Oracle Linux"
  operating_system_version = "7.6"

  # exclude GPU specific images
  filter {
    name   = "display_name"
    values = ["^Oracle-Linux-7.6-([\\.0-9]+)-([\\.0-9-]+)$"]
    regex  = true
  }
}

/*
 * Remote State Dependencies
 */

data "terraform_remote_state" "tenant_network" {
  backend = "local"

  config = {
    path = "../state/tenant/network/terraform.tfstate"
  }
}

data "terraform_remote_state" "tenant_servers" {
  backend = "local"

  config = {
    path = "../state/tenant/servers/terraform.tfstate"
  }
}

data "terraform_remote_state" "mgmt_servers" {
  backend = "local"

  config = {
    path = "../../management/state/management/servers/terraform.tfstate"
  }
}

data "terraform_remote_state" "access" {
  backend = "local"

  config = {
    path = "../../management/state/management/access/terraform.tfstate"
  }
}
