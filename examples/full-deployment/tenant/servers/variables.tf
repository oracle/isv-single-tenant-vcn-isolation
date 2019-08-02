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

variable "bastion_ssh_private_key_file" {
  type        = string
  description = "path to private ssh key to access the bastion host"
  default     = "~/.ssh/id_rsa"
}

variable "remote_ssh_public_key_file" {
  type        = string
  description = "path to public ssh key for all instances deployed in the environment"
  default     = "~/.ssh/id_rsa.pub"
}

variable "remote_ssh_private_key_file" {
  type        = string
  description = "path to private ssh key to acccess all instance in the deployed environment"
  default     = "~/.ssh/id_rsa"
}
