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

variable peering_lpg_id {
  type        = string
  description = "Peering VCN LPG id to peer with tenant vcn"
}

variable igw_name {
  type        = string
  description = "Internet gateway name for management VCN"
  default     = "igw"
}

variable nat_name {
  type        = string
  description = "NAT gateway name for management VCN"
  default     = "nat"
}

variable public_rte_name {
  type        = string
  description = "route table namefor public subnet"
  default     = "public_rte"
}

variable private_rte_name {
  type        = string
  description = "route table namefor private subnet"
  default     = "private_rte"
}

variable tenant_public_sec_list {
  type        = string
  description = "seclist to open ports 80/443 to allow access to nagios server"
  default     = "tenant_public_sec_list"
}

variable tenant_private_sec_list {
  type        = string
  description = "seclist to open ICMP ports"
  default     = "tenant_private_sec_list"
}

variable tenant_public_subnet_name {
  type        = string
  description = "public Subnet display name"
  default     = "public subnet"
}

variable tenant_public_subnet_dns_label {
  type        = string
  description = "Access Subnet display name"
  default     = "peering"
}

variable tenant_public_subnet_cidr {
  type        = string
  description = "CIDR range for the peering subnet"
}

variable tenant_private_subnet_name {
  type        = string
  description = "Tenant Subnet display name"
  default     = "private subnet"
}

variable tenant_private_subnet_dns_label {
  type        = string
  description = "Tenant Subnet display name"
  default     = "tenant"
}

variable tenant_private_subnet_cidr {
  type        = string
  description = "CIDR range for the tenant subnet"
}

variable management_peering_subnet_cidr {
  type        = string
  description = "CIDR range for the tenant subnet"
}

variable tenant_peering_subnet_cidr {
  type        = string
  description = "CIDR range for the tenant subnet"
}

