
variable vnic_id {}

variable peering_subnet_cidr {}
variable tenant_vcn_cidrs {}

variable bastion_host {}

variable bastion_ssh_private_key_file {
  type        = string
  description = "the private ssh key file to access the bastion instance"
  default     = "~/.ssh/id_rsa"
}

variable ssh_host {}

variable ssh_private_key_file {
  type        = string
  description = "the private ssh key to access the instance for provisioning"
  default     = "~/.ssh/id_rsa"
}

