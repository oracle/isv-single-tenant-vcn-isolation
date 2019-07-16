variable display_name {
  type        = string
  description = "root compartment for the individual tenant compartments"
  default     = "lb1"
}

variable hostname_label {
  type        = string
  description = "compartment name"
  default     = "bastion"
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

variable shape {
  type        = string
  description = "shape of load balancer"
  default     = "100Mbps"
}
variable compartment_id {}
variable subnet_id {}
variable availability_domain {}
variable management_private_ip {}