
terraform {
  required_version = ">= 0.12.0"
}

resource oci_core_vcn peering_vcn {
  compartment_id = var.compartment_id
  display_name   = "Tenant Peering VCN"
  dns_label      = "peering"
  cidr_block     = var.vcn_cidr_block
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource oci_core_route_table peering_route_table {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.peering_vcn.id
  display_name   = "Local Peering Routes to Tenant VCNs"

  # TODO for loop over each oci_core_local_peering_gateway index
  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_vcns[0].cidr_block
    network_entity_id = oci_core_local_peering_gateway.peering_gateway[0].id
  }

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource oci_core_local_peering_gateway peering_gateway {
  count = length(var.tenant_lpgs)

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.peering_vcn.id
  display_name   = "Tenant Peering Gateway ${count.index + 1}"
  peer_id        = var.tenant_lpgs[count.index].id
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

// TODO not used - remove?
resource oci_core_security_list peering_security_list {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.peering_vcn.id
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource oci_core_subnet peering_subnet {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.peering_vcn.id
  display_name   = "Tenant Peering subnet"
  dns_label      = "subnet"
  cidr_block     = var.subnet_cidr
  route_table_id = oci_core_route_table.peering_route_table.id
  security_list_ids = [
    oci_core_vcn.peering_vcn.default_security_list_id,
    oci_core_security_list.peering_security_list.id
  ]
  prohibit_public_ip_on_vnic = true

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}
