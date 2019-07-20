variable compartment_id {}

variable display_name {
  type        = string
  description = "name of routing vnic attachment"
}

variable hostname_label {
  type        = string
  description = "hostname label to assign to the vnic, must be unique within the subnet"
}

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

variable subnet_id {
  description = "the subnet to attach the vnic to"
}
variable instance_id {
  description = "the instance to attach the vnic to"
}
 