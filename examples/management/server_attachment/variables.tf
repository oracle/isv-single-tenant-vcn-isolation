variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}

variable "compartment_name" {
	type        = string
  	description = "Compartment name for Management layer"
  	default		= "management"
}
