variable compartment_id {
  type        = string
  description = "compartment for the tenant peering resources"
}

variable vcn_cidr_block {
  type        = string
  description = "CIDR range for this tenant peering VCN"
}

variable subnet_cidr {
  type        = string
  description = "CIDR range for this tenant peering subnet"
}

variable peering_subnet_cidr {
  type        = string
  description = "CIDR range for the isv vcn peering gateway subnet"
}

variable tenant_lpgs {
  type        = list
  description = "List of tenant LPGs to peer"
}

variable tenant_vcns {
  type        = list
  description = "List of tenant VCNs to peer"
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
