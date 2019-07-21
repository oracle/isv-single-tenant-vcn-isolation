locals {
  number_of_peering_vcns     = var.number_of_tenants / var.local_peering_gateways_per_tenany_peering_vcn
  tenant_peering_vcn_newbits = var.tenant_peering_vcn_mask - tonumber(split("/", var.tenant_peering_vcn_meta_cidr)[1])
  tenant_vcn_newbits         = var.tenant_vcn_mask - tonumber(split("/", var.tenant_vcn_meta_cidr)[1])

  peering_vcns = [for n in null_resource.peering_vcns : n.triggers.network_cidr]
  tenant_vcns  = [for n in null_resource.tenant_vcns : n.triggers.network_cidr]

  tenant_vcns_per_peering_vcn = chunklist(local.tenant_vcns, var.local_peering_gateways_per_tenany_peering_vcn)
}

resource null_resource "peering_vcns" {
  count = local.number_of_peering_vcns

  triggers = {
    network_cidr = cidrsubnet(var.tenant_peering_vcn_meta_cidr, local.tenant_peering_vcn_newbits, count.index)
  }
}

resource null_resource "tenant_vcns" {
  count = var.number_of_tenants

  triggers = {
    network_cidr = cidrsubnet(var.tenant_vcn_meta_cidr, local.tenant_vcn_newbits, count.index)
  }
}

