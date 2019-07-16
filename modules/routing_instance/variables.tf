variable display_name {
  type        = string
  description = "name of routing instance"
  default     = "gateway"
}

variable hostname_label {
  type        = string
  description = "hostname label"
  default     = "gateway"
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
variable bastion_ip {}