output subnet {
    value = oci_core_subnet.peering_subnet
}

output subnet_cidr {
    value = var.subnet_cidr
}