variable display_name {
  type        = string
  description = "name of routing instance"
  default     = "private_tenant_rte_table"
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
variable management_vcn_id {}
variable management_subnet_id {}
variable management_nat_id {}
variable tenant_one_vcn_cidr_block {}
variable routing_ip {}
variable peering_subnet_id {}