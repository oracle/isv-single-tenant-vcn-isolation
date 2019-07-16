variable root_compartment_id {
  type        = string
  description = "root compartment for the individual tenant compartments"
}

variable compartment_name {
  type        = string
  description = "compartment name"
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