/*
 * Create a single VCN for resource deployments
 */
 ###### VCN #################
resource oci_core_vcn peering_vcn {
  compartment_id = var.compartment_id
  display_name   = var.vcn_name
  dns_label      = var.dns_label
  cidr_block     = var.vcn_cidr_block
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

##### Local Peering Gateway ######################
#
resource oci_core_local_peering_gateway peering_gateway {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.peering_vcn.id
  display_name   = var.vcn_name
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

#### Route Tables ################################
#
resource oci_core_route_table peering_route_table {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.peering_vcn.id
  display_name   = var.peering_rte_name

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_vcn_cidr_block
    network_entity_id = oci_core_local_peering_gateway.peering_gateway.id
  }
}

#### Security Lists ####################################
#
resource oci_core_security_list peering_security_list {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.peering_vcn.id
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

  // allow inbound http traffic
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
resource oci_core_subnet peering_subnet {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.peering_vcn.id
  display_name   = var.peering_subnet_name
  dns_label      = var.peering_subnet_dns_label
  cidr_block     = var.peering_subnet_cidr
  route_table_id = oci_core_route_table.peering_route_table.id
  security_list_ids = [
    oci_core_vcn.peering_vcn.default_security_list_id,
    oci_core_security_list.peering_security_list.id
  ]
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}
