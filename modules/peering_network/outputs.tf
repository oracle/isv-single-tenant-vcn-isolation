output peering_vcn {
  value = oci_core_vcn.peering_vcn
}

output peering_subnet {
  value = oci_core_subnet.peering_subnet
}

output peering_gateway_1 {
  value = oci_core_local_peering_gateway.peering_gateway_1
}

output peering_gateway_2 {
  value = oci_core_local_peering_gateway.peering_gateway_2
}