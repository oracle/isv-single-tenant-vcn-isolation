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

variable routing_ip_ids {
  description = "ordered list of private ip address resource ocids for the routing instances"
  type = list(string)
}

variable tenant_vcn_cidr_blocks {
  type = list(string)
}
