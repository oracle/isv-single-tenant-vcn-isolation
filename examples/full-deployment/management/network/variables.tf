# OCI Provider variables
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

# Deployment variables
variable "compartment_ocid" {
  type        = string
  description = "ocid of the compartment to deploy the resources in"
}

variable "compartment_name" {
  type        = string
  description = "compartment name for management resources"
  default     = "management"
}

variable "vcn_cidr_block" {
  type        = string
  description = "ISV vcn cidr block"
  default     = "10.254.0.0/16"
}

variable "management_subnet_cidr" {
  type        = string
  description = "ISV management subnet idr block"
  default     = "10.254.100.0/24"
}

variable "access_subnet_cidr" {
  type        = string
  description = "ISV access subnet idr block"
  default     = "10.254.99.0/24"
}

variable "peering_subnet_cidr" {
  type        = string
  description = "ISV peering subnet idr block"
  default     = "10.254.254.0/24"
}
