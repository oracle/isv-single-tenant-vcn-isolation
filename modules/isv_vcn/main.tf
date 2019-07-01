
terraform {
  required_version = ">= 0.12.0"
}

/*
 * Create a single VCN for the application deployment
 */
resource oci_core_vcn isv_vcn {
  compartment_id = var.compartment_id
  display_name   = "ISV VCN"
  dns_label      = "isv"
  cidr_block     = var.vcn_cidr_block
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource oci_core_internet_gateway management_igw {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = "Application Management Internet Gateway"
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource oci_core_nat_gateway management_nat {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = "Application Management NAT Gateway"
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource oci_core_route_table management_route_table {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = "public_rte_table"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.management_igw.id
  }
}

resource oci_core_route_table management_private_route_table {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = "private_rte_table"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.management_nat.id
  }
}

resource oci_core_security_list management_security_list {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = "management_security_list"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow inbound http traffic
  ingress_security_rules {
      tcp_options {
        min = "80"
        max = "80"
      }
      protocol = "6"
      source   = "10.254.99.0/24"
  }
  ingress_security_rules {
    tcp_options {
      min = "443"
      max = "443"
    }
    protocol = "6"
    source   = "10.254.99.0/24"
  }
}

resource oci_core_security_list peering_security_list {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = "peering_security_list"
}

resource oci_core_security_list access_security_list {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = "access_security_list"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow inbound http traffic
  ingress_security_rules {
      tcp_options {
        min = "80"
        max = "80"
      }
      protocol = "6"
      source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    tcp_options {
      min = "443"
      max = "443"
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
}

resource oci_core_subnet peering_subnet {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = "Tenant Peering subnet"
  dns_label      = "peering"
  cidr_block     = var.peering_subnet_cidr
  route_table_id = oci_core_route_table.management_private_route_table.id
  security_list_ids = [
    oci_core_vcn.isv_vcn.default_security_list_id,
    oci_core_security_list.peering_security_list.id
  ]
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource oci_core_subnet management_subnet {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = "Management subnet"
  dns_label      = "management"
  cidr_block     = var.management_subnet_cidr
  route_table_id = oci_core_route_table.management_private_route_table.id
  security_list_ids = [
    oci_core_vcn.isv_vcn.default_security_list_id,
    oci_core_security_list.management_security_list.id
  ]
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource oci_core_subnet access_subnet {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = "Access subnet"
  dns_label      = "access"
  cidr_block     = var.access_subnet_cidr
  route_table_id = oci_core_route_table.management_route_table.id
  security_list_ids = [
    oci_core_vcn.isv_vcn.default_security_list_id,
    oci_core_security_list.access_security_list.id
  ]
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}