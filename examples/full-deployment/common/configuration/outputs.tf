output "tenant_vcns" {
  value = module.network_topology.tenant_vcns
}

output "peering_vcns" {
  value = module.network_topology.peering_vcns
}

output "tenant_vcns_per_peering_vcn" {
  value = module.network_topology.tenant_vcns_per_peering_vcn
}
