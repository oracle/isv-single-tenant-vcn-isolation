variable root_compartment_id {
  type        = string
  description = "root compartment for the individual tenant compartments"
}

variable tenant_name {
  type        = string
  description = "application tenant name"
}

variable tenant_label {
  type        = string
  description = "label used for the Compartment name and DNS label [a-zA-Z0-9-_]"
}

variable vcn_cidr_block {
  type        = string
  description = "CIDR range for the tenant VCN"
}

variable public_subnet_cidr {
  type        = string
  description = "CIDR range for the public subnet"
}

variable private_subnet_cidr {
  type        = string
  description = "CIDR range for the private subnet"
}

variable isv_peering_subnet_cidr {
  type        = string
  description = "CIDR range for the ISV peering subnet"
}

variable tenant_peering_subnet_cidr {
  type        = string
  description = "CIDR range for the tenant peering subnet"
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
