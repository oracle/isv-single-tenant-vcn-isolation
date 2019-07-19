variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}

variable "display_name_1" {
  type        = string
  default     = "tenant1"
}
variable "display_name_2" {
  type        = string
  default     = "tenant2"
}
variable "display_name_3" {
  type        = string
  default     = "tenant3"
}
variable "display_name_4" {
  type        = string
  default     = "tenant4"
}

variable "vcn_cidr_block_1" {
  type        = string
  default     = "10.1.0.0/16"
}
variable "vcn_cidr_block_2" {
  type        = string
  default     = "10.2.0.0/16"
}
variable "vcn_cidr_block_3" {
  type        = string
  default     = "10.3.0.0/16"
}
variable "vcn_cidr_block_4" {
  type        = string
  default     = "10.4.0.0/16"
}

locals {
  region_map = {
    for r in data.oci_identity_regions.regions.regions :
    r.key => r.name
  }

  home_region         = lookup(local.region_map, data.oci_identity_tenancy.tenancy.home_region_key)
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")

  root_compartment_id = var.compartment_ocid
}