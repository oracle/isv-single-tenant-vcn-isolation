
data "oci_core_private_ips" "tenant_1_private_ip" {
  ip_address = var.routing_ip
  subnet_id  = var.peering_subnet_id
}

data "oci_core_private_ips" "tenant_2_private_ip" {
  ip_address = var.routing_ip
  subnet_id  = var.peering_subnet_id
}

#private route table attachment
resource oci_core_route_table management_private_rt_table {
  compartment_id = var.compartment_id
  vcn_id         = var.management_vcn_id
  display_name   = var.display_name

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = var.management_nat_id
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_1_vcn_cidr_block
    network_entity_id = lookup(data.oci_core_private_ips.tenant_1_private_ip.private_ips[0], "id")
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_2_vcn_cidr_block
    network_entity_id = lookup(data.oci_core_private_ips.tenant_1_private_ip.private_ips[0], "id")
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_3_vcn_cidr_block
    network_entity_id = lookup(data.oci_core_private_ips.tenant_2_private_ip.private_ips[0], "id")
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_4_vcn_cidr_block
    network_entity_id = lookup(data.oci_core_private_ips.tenant_2_private_ip.private_ips[0], "id")
  }
}

resource "oci_core_route_table_attachment" "management_route_table_attachment" {
  subnet_id      = var.management_subnet_id
  route_table_id = oci_core_route_table.management_private_rt_table.id
}

#public route table attachment
resource oci_core_route_table access_public_rt_table {
  compartment_id = var.compartment_id
  vcn_id         = var.management_vcn_id
  display_name   = var.display_name_public

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = var.management_igw_id
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_1_vcn_cidr_block
    network_entity_id = lookup(data.oci_core_private_ips.tenant_1_private_ip.private_ips[0], "id")
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_2_vcn_cidr_block
    network_entity_id = lookup(data.oci_core_private_ips.tenant_1_private_ip.private_ips[0], "id")
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_3_vcn_cidr_block
    network_entity_id = lookup(data.oci_core_private_ips.tenant_2_private_ip.private_ips[0], "id")
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_4_vcn_cidr_block
    network_entity_id = lookup(data.oci_core_private_ips.tenant_2_private_ip.private_ips[0], "id")
  }
}

resource "oci_core_route_table_attachment" "access_route_table_attachment" {
  subnet_id      = var.access_subnet_id
  route_table_id = oci_core_route_table.access_public_rt_table.id
}