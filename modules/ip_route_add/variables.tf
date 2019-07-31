
variable vnic_id {
  type        = string
  description = "ocid of the vNIC the route is configured for"
}

variable peering_subnet_cidr {
  type        = string
  description = "the peering network cidr to route through"
}

variable tenant_vcn_cidrs {
  type        = list
  description = "list of network cidrs accessable through this route"
}

variable bastion_host {
  type        = string
  description = "host name or ip address of the bastion host for provisioning"
}

variable bastion_ssh_private_key_file {
  type        = string
  description = "the private ssh key file to access the bastion instance"
  default     = "~/.ssh/id_rsa"
}

variable ssh_host {
  type        = string
  description = "host name or ip address of the instance to provision the ip route on"
}

variable ssh_private_key_file {
  type        = string
  description = "the private ssh key to access the instance for provisioning"
  default     = "~/.ssh/id_rsa"
}

