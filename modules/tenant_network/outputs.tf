output tenant_vcn {
  value = oci_core_vcn.tenant_vcn
}

output tenant_private_subnet {
  value = oci_core_subnet.private_subnet
}