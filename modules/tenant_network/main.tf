/*
 * Create a single VCN for resource deployments
 */
 ###### VCN #################
resource oci_core_vcn tenant_vcn {
  compartment_id = var.compartment_id
  display_name   = var.vcn_name
  dns_label      = var.dns_label
  cidr_block     = var.vcn_cidr_block
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource oci_core_internet_gateway tenant_igw {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = var.igw_name
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource oci_core_nat_gateway tenant_nat {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = var.nat_name
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}


##### Local Peering Gateway ######################
#
resource oci_core_local_peering_gateway tenant_peering_gateway {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  peer_id        = var.peering_lpg_id
  display_name   = var.vcn_name
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

#### Route Tables ################################
#
resource oci_core_route_table public_route_table {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = var.public_rte_name

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.tenant_igw.id
  }
}

resource oci_core_route_table private_route_table {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = var.private_rte_name

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.tenant_nat.id
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_peering_subnet_cidr
    network_entity_id = oci_core_local_peering_gateway.tenant_peering_gateway.id
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.management_peering_subnet_cidr
    network_entity_id = oci_core_local_peering_gateway.tenant_peering_gateway.id
  }
}


#### Security Lists ####################################
#
resource oci_core_security_list public_security_list {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = var.tenant_public_sec_list

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
}

resource oci_core_security_list private_security_list {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = var.tenant_private_sec_list

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

  // allow inbound NRPE traffic
  ingress_security_rules {
      tcp_options {
        min = "5666"
        max = "5666"
      }
      protocol = "6"
      source   = "0.0.0.0/0"
  }
}

####### SUBNETS #####################################################
#
resource oci_core_subnet public_subnet {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = var.tenant_public_subnet_name
  dns_label      = var.tenant_public_subnet_dns_label
  cidr_block     = var.tenant_public_subnet_cidr
  route_table_id = oci_core_route_table.public_route_table.id
  security_list_ids = [
    oci_core_vcn.tenant_vcn.default_security_list_id,
    oci_core_security_list.public_security_list.id
  ]
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource oci_core_subnet private_subnet {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = var.tenant_private_subnet_name
  dns_label      = var.tenant_private_subnet_dns_label
  cidr_block     = var.tenant_private_subnet_cidr
  route_table_id = oci_core_route_table.private_route_table.id
  security_list_ids = [
    oci_core_vcn.tenant_vcn.default_security_list_id,
    oci_core_security_list.private_security_list.id
  ]
  prohibit_public_ip_on_vnic = true
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}
