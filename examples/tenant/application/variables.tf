variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}

variable "compartment_name" {
    type        = string
  	description = "Compartment name for Management layer"
  	default		  = "tenant1"
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