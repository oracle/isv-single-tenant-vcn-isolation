variable display_name {
  type        = string
  description = "root compartment for the individual tenant compartments"
  default     = "bastion"
}

variable hostname_label {
  type        = string
  description = "compartment name"
  default     = "bastion"
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
variable bastion_host_ip {}
variable management_host_ip {}
variable tenant_host_ip {}