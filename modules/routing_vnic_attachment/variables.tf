variable compartment_id {}

variable display_name {
  type        = string
  description = "name of routing vnic attachment"
}

variable hostname_label {
  type        = string
  description = "hostname label to assign to the vnic, must be unique within the subnet"
}

variable bastion_host {}

variable bastion_ssh_private_key_file {
  type        = string
  description = "the private ssh key file to access the bastion instance"
  default     = "~/.ssh/id_rsa"
}

variable ssh_host {}

variable ssh_private_key_file {
  type        = string
  description = "the private ssh key to access the instance for provisioning"
  default     = "~/.ssh/id_rsa"
}

variable subnet_id {
  description = "the subnet to attach the vnic to"
}
variable instance_id {
  description = "the instance to attach the vnic to"
}
 
variable secondary_vnic_configuration_script_url {
  type        = string
  description = "location of the secondary_vnic_all_configure.sh script to be run when attaching a new secondary vnic to an instance"
  default     = "https://docs.cloud.oracle.com/iaas/Content/Resources/Assets/secondary_vnic_all_configure.sh"
  # see https://docs.cloud.oracle.com/iaas/Content/Network/Tasks/managingVNICs.htm#linux
}
