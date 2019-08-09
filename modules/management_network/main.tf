// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

/*
 * Create the ISV management VCN and related resources.
 */

# VCN
resource oci_core_vcn isv_vcn {
  compartment_id = var.compartment_id
  display_name   = var.vcn_name
  dns_label      = var.dns_label
  cidr_block     = var.vcn_cidr_block
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

# Internet Gateway
resource oci_core_internet_gateway management_igw {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = var.igw_name
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

# NAT Gateway
resource oci_core_nat_gateway management_nat {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = var.nat_name
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

# Default Route Table
resource oci_core_default_route_table isv_default_rte_table {
  manage_default_resource_id = oci_core_vcn.isv_vcn.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.management_igw.id
  }
}

# Route Table for the private subnet with NAT
resource oci_core_route_table private_route_table {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = var.private_rte_name

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.management_nat.id
  }
}

# Network Security List for management & access subnet
resource oci_core_security_list management_security_list {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = "management_security_list"

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol = 1
    source   = "0.0.0.0/0"
  }
}

# Network Security List for peering subnet
resource oci_core_security_list peering_security_list {
  compartment_id = var.peering_compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = "peering_security_list"

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol = 1
    source   = "0.0.0.0/0"
  }
}

/*
 * Security Group for HTTP
 */
# Security Group creation
resource "oci_core_network_security_group" "http_network_security_group" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id

  display_name = var.http_security_group_name
}

# adding ingress security rule for HTTP
resource "oci_core_network_security_group_security_rule" "http_network_security_group_security_rule_1" {
  network_security_group_id = oci_core_network_security_group.http_network_security_group.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.access_subnet_cidr

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

/*
 * Security Group for the Peering Subnet
 */
# Security Group creation
resource "oci_core_network_security_group" "peering_network_security_group" {
  compartment_id = var.peering_compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id

  display_name = var.peering_security_group_name
}

# adding ingress security rule for port 5666
resource "oci_core_network_security_group_security_rule" "peering_network_security_group_security_rule_1" {
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

# Access (bastion) Subnet
resource oci_core_subnet access_subnet {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.isv_vcn.id
  display_name   = var.access_subnet_name
  dns_label      = var.access_subnet_dns_label
  cidr_block     = var.access_subnet_cidr
  security_list_ids = [
    oci_core_vcn.isv_vcn.default_security_list_id,
    oci_core_security_list.management_security_list.id
  ]
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

# Peering Subnet
resource oci_core_subnet peering_subnet {
  compartment_id             = var.peering_compartment_id
  vcn_id                     = oci_core_vcn.isv_vcn.id
  display_name               = var.peering_subnet_name
  dns_label                  = var.peering_subnet_dns_label
  cidr_block                 = var.peering_subnet_cidr
  route_table_id             = oci_core_route_table.private_route_table.id
  security_list_ids = [
    oci_core_vcn.isv_vcn.default_security_list_id,
    oci_core_security_list.peering_security_list.id
  ]
  prohibit_public_ip_on_vnic = true
  defined_tags               = var.defined_tags
  freeform_tags              = var.freeform_tags
}

# Management Subnet
resource oci_core_subnet management_subnet {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.isv_vcn.id
  display_name               = var.management_subnet_name
  dns_label                  = var.management_subnet_dns_label
  cidr_block                 = var.management_subnet_cidr
  security_list_ids = [
    oci_core_vcn.isv_vcn.default_security_list_id,
    oci_core_security_list.management_security_list.id
  ]
  prohibit_public_ip_on_vnic = true
  defined_tags               = var.defined_tags
  freeform_tags              = var.freeform_tags
}