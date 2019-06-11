variable compartment_id {
  type        = string
  description = "compartment for the management resources"
}

variable vcn_cidr_block {
  type        = string
  description = "CIDR range for the management VCN"
}

variable access_subnet_cidr {
  type        = string
  description = "CIDR range for the access subnet"
}

variable peering_subnet_cidr {
  type        = string
  description = "CIDR range for the tenant peering subnet"
}

variable management_subnet_cidr {
  type        = string
  description = "CIDR range for the management subnet"
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
