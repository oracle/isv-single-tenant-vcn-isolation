variable display_name {
  type        = string
  description = "root compartment for the individual tenant compartments"
  default     = "appserver"
}

variable hostname_label {
  type        = string
  description = "compartment name"
  default     = "appserver"
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
variable source_id {}
variable subnet_id {}
variable availability_domain {}
variable tenant_private_ip {}
variable bastion_ip {}