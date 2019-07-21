module network_topology {
  source = "../../modules/network_calculator"

  number_of_tenants = 4

  routing_instances_subnet_cidr = "10.254.100.0/24"

  tenant_peering_vcn_meta_cidr = "10.253.0.0/16"
  tenant_peering_vcn_mask      = 29

  tenant_vcn_meta_cidr = "10.1.0.0/16"
  tenant_vcn_mask      = 24

  peering_vcns_per_routing_instance             = 1
  local_peering_gateways_per_tenany_peering_vcn = 2

}

output "tenant_vcns" {
  value = module.network_topology.tenant_vcns
}

output "peering_vcns" {
  value = module.network_topology.peering_vcns
}

output "tenant_vcns_per_peering_vcn" {
  value = module.network_topology.tenant_vcns_per_peering_vcn
}
