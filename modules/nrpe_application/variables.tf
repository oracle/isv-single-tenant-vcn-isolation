variable nagios_server_ip {
  type        = string
  description = "host name or ip address of the nagios server"
}

# TODO rename to `bastion_host` for consistency
variable bastion_host_ip {
  type        = string
  description = "host name or ip address of the bastion host for provisioning"
}

variable tenant_ip {
  type        = string
  description = "host name or ip address of the tenant instance to provision the agent on"
}

variable bastion_ssh_private_key_file {
  type        = string
  description = "the private ssh key file to access the bastion instance"
  default     = "~/.ssh/id_rsa"
}

variable remote_ssh_private_key_file {
  type        = string
  description = "the private ssh key to provision on the bastion host for access to remote instances"
  default     = "~/.ssh/id_rsa"
}
