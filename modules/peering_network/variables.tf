variable compartment_id {
  type        = string
  description = "compartment for the management resources"
}

variable vcn_name {
  type        = string
  description = "CIDR range for the management VCN"
}

variable dns_label {
  type        = string
  description = "CIDR range for the management VCN"
  default     = ""
}

variable vcn_cidr_block {
  type        = string
  description = "CIDR range for the management VCN"
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

variable peering_rte_name {
  type        = string
  description = "Local Peering Routes to Tenant VCNs"
  default     = "peering_rte"
}

variable peering_sec_list {
  type        = string
  description = "seclist to open ports 80/443 to allow access to nagios server"
  default     = "peering_sec_list"
}

variable tenant_vcn_cidr_block {
  type        = string
  description = "seclist to open ICMP ports"
}

variable peering_subnet_name {
  type        = string
  description = "peering Subnet display name"
  default     = "peering subnet"
}

variable peering_subnet_dns_label {
  type        = string
  description = "Peering Subnet display name"
  default     = "peering"
}

variable peering_subnet_cidr {
  type        = string
  description = "CIDR range for the peering subnet"
}


