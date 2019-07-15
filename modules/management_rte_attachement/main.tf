
data "oci_core_private_ips" "tenant_private_ip" {
    #Required
    ip_address  = var.routing_ip
    subnet_id   = var.peering_subnet_id
}

resource oci_core_route_table management_private_rt_table {
  compartment_id = var.compartment_id
  vcn_id         = var.management_vcn_id
  display_name   = var.display_name

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = var.management_nat_id
  }

  route_rules {
    destination_type   = "CIDR_BLOCK"
    destination        = var.tenant_one_vcn_cidr_block
    network_entity_id = "${lookup(data.oci_core_private_ips.tenant_private_ip.private_ips[0], "id")}"
  }
}

resource "oci_core_route_table_attachment" "management_route_table_attachment" {
  #Required 
  subnet_id = var.management_subnet_id
  route_table_id ="${oci_core_route_table.management_private_rt_table.id}"
}