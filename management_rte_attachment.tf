resource oci_core_route_table management_private_rte_table {
  compartment_id = var.compartment_ocid
  vcn_id         = "${module.isv_vcn.isv_vcn.id}"
  display_name   = "private_rte_table"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = "${module.isv_vcn.management_nat.id}"
  }

  route_rules {
    destination       = "${oci_core_instance.tenantone_appserver1.private_ip}"
    network_entity_id = "${oci_core_instance.gateway1.private_ip}"
  }
}

resource "oci_core_route_table_attachment" "management_route_table_attachment" {
  #Required 
  subnet_id = "${module.isv_vcn.management_subnet.id}"
  route_table_id ="${oci_core_route_table.management_private_rte_table.id}"
}