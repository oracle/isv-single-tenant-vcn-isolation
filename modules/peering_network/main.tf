// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

/*
 * Create a tenant peering network used for routing between the management VCN and
 * the locally peering tenant VCNs
 */

# Peering VCN
resource oci_core_vcn peering_vcn {
  compartment_id = var.compartment_id
  display_name   = var.vcn_name
  dns_label      = var.dns_label
  cidr_block     = var.vcn_cidr_block
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

# Local Peering Gateways (one per peering Tenant VCN)
resource oci_core_local_peering_gateway peering_gateways {
  count          = var.local_peering_gateways_per_vcn
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.peering_vcn.id
  display_name   = "${var.vcn_name} local peering gateway ${count.index + 1}"
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

# Peering Route Table
resource oci_core_route_table peering_route_table {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.peering_vcn.id
  display_name   = var.peering_rte_name

  # TODO use dynamic nested block with for_each to create route_rules
  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_vcn_cidr_blocks[0]
    network_entity_id = oci_core_local_peering_gateway.peering_gateways[0].id
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_vcn_cidr_blocks[1]
    network_entity_id = oci_core_local_peering_gateway.peering_gateways[1].id
  }
}

/*
 * Security Group
 */

# Security Group creation
resource "oci_core_network_security_group" "peering_network_security_group" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.peering_vcn.id

    display_name = var.peering_security_group_name
}

# adding egress security rule to security group
resource "oci_core_network_security_group_security_rule" "peering_network_security_group_security_rule_0" {
  network_security_group_id = oci_core_network_security_group.peering_network_security_group.id

  direction   = "EGRESS"
  protocol    = "all"
  destination = "0.0.0.0/0"
}

# adding ingress security rule for ICMP
resource "oci_core_network_security_group_security_rule" "peering_network_security_group_security_rule_1" {
  network_security_group_id = oci_core_network_security_group.peering_network_security_group.id
  protocol                  = "1"
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"
}

# adding ingress security rule 5666 to security group
resource "oci_core_network_security_group_security_rule" "peering_network_security_group_security_rule_2" {
  network_security_group_id = oci_core_network_security_group.peering_network_security_group.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 5666
      max = 5666
    }
  }
}

/*
 * SUBNETS
 */

# Peering Subnet
resource oci_core_subnet peering_subnet {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.peering_vcn.id
  display_name   = var.peering_subnet_name
  dns_label      = var.peering_subnet_dns_label
  cidr_block     = var.peering_subnet_cidr
  route_table_id = oci_core_route_table.peering_route_table.id
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}
