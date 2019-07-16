output vcn {
  value = oci_core_vcn.isv_vcn
}

output management_subnet {
  value = oci_core_subnet.management_subnet
}

output access_subnet {
  value = oci_core_subnet.access_subnet
}

output peering_subnet {
  value = oci_core_subnet.peering_subnet
}

output nat_id {
  value = oci_core_nat_gateway.management_nat.id
}

output igw_id {
  value = oci_core_internet_gateway.management_igw.id
}