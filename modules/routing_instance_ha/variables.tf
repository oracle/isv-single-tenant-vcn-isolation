variable display_name {
  type        = string
  description = "name of routing instance"
  default     = "gateway"
}

variable hostname_label {
  type        = string
  description = "hostname label"
  default     = "gateway"
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
variable source_id {}
variable subnet_id {}
variable availability_domain {}
variable bastion_ip {}

variable shape {
  type        = string
  description = "oci instance shape"
  default     = "VM.Standard2.1"
}

variable bastion_ssh_private_key_file {
  type        = string
  description = "the private ssh key file to access the bastion instance"
  default     = "~/.ssh/id_rsa"
}

variable ssh_public_key_file {
  type        = string
  description = "the public ssh key file to be added to the instance ssh_authorized_keys"
  default     = "~/.ssh/id_rsa.pub"
}

variable ssh_private_key_file {
  type        = string
  description = "the private ssh key to access the instance for provisioning"
  default     = "~/.ssh/id_rsa"
}

variable hacluster_password {
  type        = string
  description = "password for the HA cluster (must be at least 8 characters containing uppercase, lowercase, digits, and non-alphanumeric characters)"
  # values that do not meet the required password criteria will generate the following error during provisioning:
  # `passwd: Have exhausted maximum number of retries for service`
  default = "^Ch@ngem3" // TODO REMOVE
}

variable monitor_interval {
  type        = number
  description = "cluster monitor interval in seconds"
  default     = 20
}