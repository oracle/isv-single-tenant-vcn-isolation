
output vcn {
  value = oci_core_vcn.tenant_vcn
}

output lpg {
  value = oci_core_local_peering_gateway.tenant_peering_gateway
}

output public_subnet {
  value = oci_core_subnet.public_subnet
}

output private_subnet {
  value = oci_core_subnet.private_subnet
}

output compartment_id {
  value = oci_identity_compartment.tenant_compartment.id
}