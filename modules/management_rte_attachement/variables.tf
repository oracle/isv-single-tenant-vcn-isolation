variable display_name {
  type        = string
  description = "name of routing instance"
  default     = "private_tenant_rte_table"
}

variable display_name_public {
  type        = string
  description = "name of routing instance"
  default     = "public_tenant_rte_table"
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
variable management_igw_id {}
variable access_subnet_id {}
variable tenant_1_vcn_cidr_block {}
variable tenant_2_vcn_cidr_block {}
variable tenant_3_vcn_cidr_block {}
variable tenant_4_vcn_cidr_block {}
variable routing_ip {}
variable peering_subnet_id {}