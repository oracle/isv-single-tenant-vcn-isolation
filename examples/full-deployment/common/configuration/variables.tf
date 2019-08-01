# dummy variables
# these aren't needed but are declared suppress the terragrunt warnings

variable "tenancy_ocid" { default = null }
variable "user_ocid" { default = null }
variable "fingerprint" { default = null }
variable "private_key_path" { default = null }
variable "region" { default = null }
variable "compartment_ocid" { default = null }

variable "bastion_ssh_private_key_file" { default = null }
variable "bastion_ssh_public_key_file" { default = null }
variable "remote_ssh_public_key_file" { default = null }
variable "remote_ssh_private_key_file" { default = null }
