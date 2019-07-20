variable display_name {
  type        = string
  description = "name of routing instance"
  default     = "gw1peer1"
}

variable hostname_label {
  type        = string
  description = "hostname label"
  default     = "gw1peer1"
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
variable tenant_1_vcn_cidr_block {}
variable tenant_2_vcn_cidr_block {}
variable tenant_3_vcn_cidr_block {
  default = null
  # TODO pass list of vcn cidrs
}
variable tenant_4_vcn_cidr_block {
    default = null
  # TODO pass list of vcn cidrs
}

variable peering_1_subnet_cidr {}
variable peering_2_subnet_cidr {  
  default = null
  # TODO pass list of vcn cidrs
}

variable peering_1_vnic_id {}
variable peering_2_vnic_id {
  default = null
  # TODO pass list of vnic_ids
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

variable vnic_id {}
