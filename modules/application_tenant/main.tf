
terraform {
  required_version = ">= 0.12.0"
}

/*
 * Default oci provider for provisioning the resources in the target region
 */
provider oci {
}

/*
 * The `home` provider is used for IAM provisioning in the home region
 */
provider oci {
  alias = "home"
}

/*
 * Create a separate compartment per applicaiton tenant. The compartment is used for grouping all
 * infrastructure resources used to provision the tenant specific application deployment.
 */
resource oci_identity_compartment tenant_compartment {
  provider       = "oci.home"
  compartment_id = var.root_compartment_id
  name           = var.tenant_label
  description    = "Application Tenant Compartment for ${var.tenant_name}"
  enable_delete  = true
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

/*
 * Create a single VCN for the application deployment
 */
resource oci_core_vcn tenant_vcn {
  compartment_id = oci_identity_compartment.tenant_compartment.id
  display_name   = "Application Tenant VCN for ${var.tenant_name}"
  dns_label      = var.tenant_label
  cidr_block     = var.vcn_cidr_block
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource oci_core_internet_gateway tenant_igw {
  compartment_id = oci_identity_compartment.tenant_compartment.id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = "Application Tenant Internet Gateway for ${var.tenant_name}"
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource oci_core_nat_gateway tenant_nat {
  compartment_id = oci_identity_compartment.tenant_compartment.id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = "Application Tenant NAT Gateway for ${var.tenant_name}"
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource oci_core_local_peering_gateway tenant_peering_gateway {
  compartment_id = oci_identity_compartment.tenant_compartment.id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = "Application Tenant Peering Gateway for ${var.tenant_name}"
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource oci_core_route_table public_route_table {
  compartment_id = oci_identity_compartment.tenant_compartment.id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = "Route Table for Public Subnet"

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.tenant_igw.id
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_peering_subnet_cidr
    network_entity_id = oci_core_local_peering_gateway.tenant_peering_gateway.id
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.isv_peering_subnet_cidr
    network_entity_id = oci_core_local_peering_gateway.tenant_peering_gateway.id
  }

}

resource oci_core_security_list public_security_list {
  compartment_id = oci_identity_compartment.tenant_compartment.id
  vcn_id         = oci_core_vcn.tenant_vcn.id
}

resource "oci_core_subnet" "public_subnet" {
  compartment_id = oci_identity_compartment.tenant_compartment.id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = "Public subnet"
  dns_label      = "public"
  cidr_block     = var.public_subnet_cidr
  route_table_id = oci_core_route_table.public_route_table.id
  security_list_ids = [
    oci_core_vcn.tenant_vcn.default_security_list_id,
    oci_core_security_list.public_security_list.id
  ]
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource oci_core_route_table private_route_table {
  compartment_id = oci_identity_compartment.tenant_compartment.id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = "Route Table for Private Subnet"

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.tenant_nat.id
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.tenant_peering_subnet_cidr
    network_entity_id = oci_core_local_peering_gateway.tenant_peering_gateway.id
  }

  route_rules {
    destination_type  = "CIDR_BLOCK"
    destination       = var.isv_peering_subnet_cidr
    network_entity_id = oci_core_local_peering_gateway.tenant_peering_gateway.id
  }
}

resource oci_core_security_list private_security_list {
  compartment_id = oci_identity_compartment.tenant_compartment.id
  vcn_id         = oci_core_vcn.tenant_vcn.id
}

resource "oci_core_subnet" "private_subnet" {
  compartment_id = oci_identity_compartment.tenant_compartment.id
  vcn_id         = oci_core_vcn.tenant_vcn.id
  display_name   = "Private subnet"
  dns_label      = "private"
  cidr_block     = var.private_subnet_cidr
  route_table_id = oci_core_route_table.private_route_table.id
  security_list_ids = [
    oci_core_vcn.tenant_vcn.default_security_list_id,
    oci_core_security_list.private_security_list.id
  ]
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags

  prohibit_public_ip_on_vnic = true
}
