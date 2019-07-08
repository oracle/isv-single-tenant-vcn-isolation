output isv_vcn {
    value = oci_core_vcn.isv_vcn
}

output access_subnet {
    value = oci_core_subnet.access_subnet
}

output management_subnet {
    value = oci_core_subnet.management_subnet
}

output peering_subnet {
    value = oci_core_subnet.peering_subnet
}

output management_nat {
    value = oci_core_nat_gateway.management_nat
}