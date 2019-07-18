variable display_name {
  type        = string
  description = "name of routing instance"
}

variable hostname_label {
  type        = string
  description = "hostname label"
}

variable freeform_tags {
  type        = map
  description = "map of freeform tags to apply to all resources created by this module"
  default     = {}
}

variable defined_tags {
  type        = map
  description = "map of defined tags to apply to all resources created by this module"
  default     = {}
}

variable compartment_id {}
variable bastion_ip {}
variable routing_instance_id {}
variable routing_ip {}
variable tenant_one_vcn_cidr_block {}
variable peering_subnet_cidr {}
variable peering_subnet_id {}

variable bastion_ssh_private_key_file {
  type        = string
  description = "the private ssh key file to access the bastion instance"
  default     = "~/.ssh/id_rsa"
}

variable ssh_private_key_file {
  type        = string
  description = "the private ssh key to access the instance for provisioning"
  default     = "~/.ssh/id_rsa"
}
