
data "oci_core_private_ips" "tenant_private_ip" {
    #Required
    ip_address = "${oci_core_instance.gateway1.private_ip}"
    subnet_id = "${module.isv_vcn.peering_subnet.id}"
}

resource oci_core_route_table management_private_rt_table {
  compartment_id = var.compartment_ocid
  vcn_id         = "${module.isv_vcn.isv_vcn.id}"
  display_name   = "private_tenant_rte_table"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = "${module.isv_vcn.management_nat.id}"
  }

  route_rules {
    destination_type   = "CIDR_BLOCK"
    destination        = "${module.tenant_one.vcn.cidr_block}"
    network_entity_id = "${lookup(data.oci_core_private_ips.tenant_private_ip.private_ips[0], "id")}"
  }
}

resource "oci_core_route_table_attachment" "management_route_table_attachment" {
  #Required 
  subnet_id = "${module.isv_vcn.management_subnet.id}"
  route_table_id ="${oci_core_route_table.management_private_rt_table.id}"
}