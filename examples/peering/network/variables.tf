variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}

variable "compartment_name" {
  type        = string
  description = "Compartment name for Peering layer"
  default     = "peering"
}

variable "display_name_1" {
  type        = string
  default     = "peering1"
}
variable "display_name_2" {
  type        = string
  default     = "peering2"
}
variable "vcn_cidr_block_1" {
  type        = string
  default     = "10.253.1.0/29"
}
variable "vcn_cidr_block_2" {
  type        = string
  default     = "10.253.1.8/29"
}


locals {
  region_map = {
    for r in data.oci_identity_regions.regions.regions :
    r.key => r.name
  }

  home_region         = lookup(local.region_map, data.oci_identity_tenancy.tenancy.home_region_key)
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")

  root_compartment_id   = var.compartment_ocid
  tenant_one_private_ip = "10.1.1.2"
  tenant_two_private_ip = "10.1.1.3"
}