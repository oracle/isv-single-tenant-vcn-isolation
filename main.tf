terraform {
  required_version = ">= 0.12.0"
}

locals {
  region_map = {
    for r in data.oci_identity_regions.regions.regions:
    r.key => r.name
  }
  home_region             = lookup(local.region_map, data.oci_identity_tenancy.tenancy.home_region_key)
  availability_domain     = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  root_tenant_compartment = var.compartment_ocid
  tenant_one_private_ip   = "10.1.1.2"
  tenant_two_private_ip   = "10.1.1.3"
}

# Configure the ISV networks
module isv_vcn {
  source = "./modules/isv_vcn"

  compartment_id         = local.root_tenant_compartment
  vcn_cidr_block         = "10.254.0.0/16"
  peering_subnet_cidr    = "10.254.254.0/24"
  management_subnet_cidr = "10.254.100.0/24"
  access_subnet_cidr     = "10.254.99.0/24"
}

# Single Tenant Peering VCN for peeering with up to 10 Tenant VCNs
# TODO Provision multiple Peering VCNs
module tenant_peering_vcn {
  source = "./modules/tenant_peering_vcn"

  compartment_id = local.root_tenant_compartment
  vcn_cidr_block = "10.253.0.0/30"
  subnet_cidr    = "10.253.0.0/30"

  # CIDR of the subent in the ISV VCN
  peering_subnet_cidr = "10.254.0.0/24" # TODO get from var

  # List of Tenant VCNs and their Local Peering Gateways
  # TODO change to a map of tenant vcn -> lpg
  tenant_lpgs = [
    module.tenant_one.lpg
  ]

  tenant_vcns = [
    module.tenant_one.vcn
  ]

}

# Single Tenant VCN
module tenant_one {
  source = "./modules/application_tenant"

  providers = {
    oci.home = "oci.home"
  }

  root_compartment_id = local.root_tenant_compartment
  tenant_name         = "Tenant 1"
  tenant_label        = "tenant1"
  vcn_cidr_block      = "10.1.0.0/22" # TODO could be a /23 is only two /24 subnets are needed
  public_subnet_cidr  = "10.1.0.0/24"
  private_subnet_cidr = "10.1.1.0/24"

  # The tenant peering VCN this tenant VCN is connected through (used for route config)
  tenant_peering_subnet_cidr = "10.253.0.0/30" # TODO get from var

  # The ISV peering VCN this tenant VCN is connected through (used for route config)
  isv_peering_subnet_cidr = "10.254.0.0/24" # TODO get from var

  freeform_tags = {
    "Tenant" = "tenant1"
  }
}

# Single Tenant VCN
module tenant_two {
  source = "./modules/application_tenant"

  providers = {
    oci.home = "oci.home"
  }

  root_compartment_id = local.root_tenant_compartment
  tenant_name         = "Tenant 2"
  tenant_label        = "tenant2"
  vcn_cidr_block      = "10.1.4.0/22" # TODO could be a /23 is only two /24 subnets are needed
  public_subnet_cidr  = "10.1.4.0/24"
  private_subnet_cidr = "10.1.5.0/24"

  # The tenant peering VCN this tenant VCN is connected through (used for route config)
  tenant_peering_subnet_cidr = "10.253.0.0/30" # TODO get from var

  # The ISV peering VCN this tenant VCN is connected through (used for route config)
  isv_peering_subnet_cidr = "10.254.0.0/24" # TODO get from var

  freeform_tags = {
    "Tenant" = "tenant2"
  }
}

