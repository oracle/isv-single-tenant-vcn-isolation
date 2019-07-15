/*
 * Create a single VCN for resource deployments
 */
 ###### VCN #################
resource oci_core_vcn isv_vcn {
  compartment_id = var.compartment_id
  display_name   = var.vcn_name
  dns_label      = var.dns_label
  cidr_block     = var.vcn_cidr_block
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource oci_core_internet_gateway management_igw {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = var.igw_name
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource oci_core_nat_gateway management_nat {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = var.nat_name
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

#### Route Tables ################################
#

resource oci_core_default_route_table default {
  manage_default_resource_id = oci_core_vcn.isv_vcn.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.management_igw.id
  }
}

resource oci_core_route_table public_route_table {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = var.public_rte_name

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.management_igw.id
  }
}

resource oci_core_route_table private_route_table {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = var.private_rte_name

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.management_nat.id
  }
}


#### Security Lists ####################################
#
resource oci_core_security_list management_security_list {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = var.management_sec_list

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
  }

  // allow inbound http traffic
  ingress_security_rules {
      tcp_options {
        min = "80"
        max = "80"
      }
      protocol = "6"
      source   = var.access_subnet_cidr
  }
  ingress_security_rules {
    tcp_options {
      min = "443"
      max = "443"
    }
    protocol = "6"
    source   = var.access_subnet_cidr
  }
}

resource oci_core_security_list peering_security_list {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = var.peering_sec_list

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
  }
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

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
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

####### SUBNETS #####################################################
#
resource oci_core_subnet access_subnet {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = var.access_subnet_name
  dns_label      = var.access_subnet_dns_label
  cidr_block     = var.access_subnet_cidr
  # route_table_id = oci_core_route_table.public_route_table.id
  security_list_ids = [
    oci_core_vcn.isv_vcn.default_security_list_id,
    oci_core_security_list.access_security_list.id
  ]
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource oci_core_subnet peering_subnet {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = var.peering_subnet_name
  dns_label      = var.peering_subnet_dns_label
  cidr_block     = var.peering_subnet_cidr
  security_list_ids = [
    oci_core_vcn.isv_vcn.default_security_list_id,
    oci_core_security_list.peering_security_list.id
  ]
  prohibit_public_ip_on_vnic = true
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource oci_core_subnet management_subnet {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = var.management_subnet_name
  dns_label      = var.management_subnet_dns_label
  cidr_block     = var.management_subnet_cidr
  # route_table_id = oci_core_route_table.private_route_table.id
  security_list_ids = [
    oci_core_vcn.isv_vcn.default_security_list_id,
    oci_core_security_list.management_security_list.id
  ]
  prohibit_public_ip_on_vnic = true
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}