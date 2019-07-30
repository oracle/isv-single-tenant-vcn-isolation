# dummy variables
# these aren't needed but are declared suppress the terragrunt warnings

variable "tenancy_ocid" { default = null }
variable "user_ocid" { default = null }
variable "fingerprint" { default = null }
variable "private_key_path" { default = null }
variable "region" { default = null }
variable "compartment_ocid" { default = null }
