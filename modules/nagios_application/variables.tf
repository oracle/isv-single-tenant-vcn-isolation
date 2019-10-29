// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable display_name {
  type        = string
  description = "root compartment for the individual tenant compartments"
  default     = "bastion"
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

variable compartment_id {
  type        = string
  description = "ocid of the compartment to provision the resources in"
}

# TODO rename to `bastion_host` for consistency
variable bastion_host_ip {
  type        = string
  description = "host name or ip address of the bastion host for provisioning"
}

variable management_host_ip {
  type        = string
  description = "host name or ip address of the instance to provision the application on"
}

variable tenant_host_ips {
  type        = string
  description = "list of tenant host ips"
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

variable nagios_administrator_password {
  type        = string
  description = "initial password for nagios application login"
}
