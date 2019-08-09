// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

/*
 * Create a VCN and related resources for tenant deployments
 */

# Tenant VCN
resource oci_core_vcn tenant_vcn {
  compartment_id = var.compartment_id
  display_name   = var.vcn_name
  dns_label      = var.dns_label
  cidr_block     = var.vcn_cidr_block
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

# Internet Gateway
resource oci_core_internet_gateway tenant_igw {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = var.igw_name
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

# NAT Gateway
resource oci_core_nat_gateway tenant_nat {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = var.nat_name
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

# Local Peering Gateway
resource oci_core_local_peering_gateway tenant_peering_gateway {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  peer_id        = var.peering_lpg_id
  display_name   = var.vcn_name
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

# Public Subnet Route Table
resource oci_core_route_table public_route_table {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = var.public_rte_name

  // internet access through internet gateway
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.tenant_igw.id
  }

  // route to peering network
  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_peering_subnet_cidr
    network_entity_id = oci_core_local_peering_gateway.tenant_peering_gateway.id
  }

  // route to management network
  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.management_peering_subnet_cidr
    network_entity_id = oci_core_local_peering_gateway.tenant_peering_gateway.id
  }
}

# Private Subnet Route Table
resource oci_core_route_table private_route_table {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = var.private_rte_name

  // internet access through nat gateway
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.tenant_nat.id
  }

  // route to peering network
  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_peering_subnet_cidr
    network_entity_id = oci_core_local_peering_gateway.tenant_peering_gateway.id
  }

  // route to management network
  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.management_peering_subnet_cidr
    network_entity_id = oci_core_local_peering_gateway.tenant_peering_gateway.id
  }
}

/*
 * Security Group
 */
# Security Group creation
resource "oci_core_network_security_group" "nrpe_network_security_group" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id

  display_name = var.nrpe_security_group_name
}

# adding egress security rule to security group
resource "oci_core_network_security_group_security_rule" "nrpe_network_security_group_security_rule_0" {
  network_security_group_id = oci_core_network_security_group.nrpe_network_security_group.id

  direction   = "EGRESS"
  protocol    = "all"
  destination = "0.0.0.0/0"
}

# adding ingress security rule to security group
resource "oci_core_network_security_group_security_rule" "nrpe_network_security_group_security_rule_1" {
  network_security_group_id = oci_core_network_security_group.nrpe_network_security_group.id
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

# adding ingress security rule for ICMP
resource "oci_core_network_security_group_security_rule" "peering_network_security_group_security_rule_2" {
  network_security_group_id = oci_core_network_security_group.nrpe_network_security_group.id
  protocol                  = "1"
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"
}

/*
 * SUBNETS
 */

# Public Subnet
resource oci_core_subnet public_subnet {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = var.tenant_public_subnet_name
  dns_label      = var.tenant_public_subnet_dns_label
  cidr_block     = var.tenant_public_subnet_cidr
  route_table_id = oci_core_route_table.public_route_table.id
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

# Private Subnet
resource oci_core_subnet private_subnet {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.tenant_vcn.id
  display_name               = var.tenant_private_subnet_name
  dns_label                  = var.tenant_private_subnet_dns_label
  cidr_block                 = var.tenant_private_subnet_cidr
  route_table_id             = oci_core_route_table.private_route_table.id
  prohibit_public_ip_on_vnic = true
  defined_tags               = var.defined_tags
  freeform_tags              = var.freeform_tags
}
