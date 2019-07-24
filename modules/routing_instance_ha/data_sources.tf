data oci_core_subnet subnet {
  subnet_id = var.subnet_id
}

data "oci_identity_fault_domains" "fault_domains" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
}

locals {
  vcn_id       = data.oci_core_subnet.subnet.vcn_id
  cidr_netmask = split("/", data.oci_core_subnet.subnet.cidr_block)[1]
}

