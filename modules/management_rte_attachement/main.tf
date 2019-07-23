
#private route table attachment
resource oci_core_route_table management_private_rt_table {
  compartment_id = var.compartment_id
  vcn_id         = var.management_vcn_id
  display_name   = var.display_name

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = var.management_nat_id
  }

  # TODO using dynamic for_each
  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_vcn_cidr_blocks[0]
    network_entity_id = var.routing_ip_ids[0]
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_vcn_cidr_blocks[1]
    network_entity_id = var.routing_ip_ids[0]
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_vcn_cidr_blocks[2]
    network_entity_id = var.routing_ip_ids[1]
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_vcn_cidr_blocks[3]
    network_entity_id = var.routing_ip_ids[1]
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

  # TODO using dynamic for_each
  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_vcn_cidr_blocks[0]
    network_entity_id = var.routing_ip_ids[0]
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_vcn_cidr_blocks[1]
    network_entity_id = var.routing_ip_ids[0]
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_vcn_cidr_blocks[2]
    network_entity_id = var.routing_ip_ids[1]
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_vcn_cidr_blocks[3]
    network_entity_id = var.routing_ip_ids[1]
  }
}

resource "oci_core_route_table_attachment" "access_route_table_attachment" {
  subnet_id      = var.access_subnet_id
  route_table_id = oci_core_route_table.access_public_rt_table.id
}