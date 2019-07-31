variable display_name {
  type        = string
  description = "name of management instance"
  default     = "management"
}

variable hostname_label {
  type        = string
  description = "hostname label"
  default     = "management"
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

variable compartment_id {
  type        = string
  description = "ocid of the compartment to provision the resources in"
}

variable source_id {
  type        = string
  description = "ocid of the image to provistion the management instance with"
}

variable subnet_id {
  type        = string
  description = "ocid of the subnet to provision the management instance in"
}

variable availability_domain {
  type        = string
  description = "the availability downmain to provision the management instance in"
}

# TODO rename to `bastion_host` for consistency
variable bastion_ip {
  type        = string
  description = "host name or ip address of the bastion host for provisioning"
}

variable shape {
  type        = string
  description = "oci shape for the instance"
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
