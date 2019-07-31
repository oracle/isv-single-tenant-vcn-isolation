Tenant and Peering VCN Network CIDR Calculator
==============================================

This helper module calculates the set of tenant and peering network VCN CIDR blocks based on the provider parameters and output the list of network CIDRs that can be used during network creation.


## Example usage

```
module network_topology {
  source = "../../modules/network_calculator"

  number_of_tenants             = 30
  routing_instances_subnet_cidr = "10.254.100.0/24"
  tenant_peering_vcn_meta_cidr  = "10.253.0.0/16"
  tenant_peering_vcn_mask       = 29
  tenant_vcn_meta_cidr          = "10.1.0.0/16"
  tenant_vcn_mask               = 24

  peering_vcns_per_routing_instance             = 3
  local_peering_gateways_per_tenany_peering_vcn = 10
}

```

### Example output

```
Outputs:

peering_vcns = [
  "10.253.0.0/29",
  "10.253.0.8/29",
  "10.253.0.16/29",
]
tenant_vcns = [
  "10.1.0.0/24",
  "10.1.1.0/24",
  "10.1.2.0/24",
  "10.1.3.0/24",
  "10.1.4.0/24",
  "10.1.5.0/24",
  "10.1.6.0/24",
  "10.1.7.0/24",
  "10.1.8.0/24",
  "10.1.9.0/24",
  "10.1.10.0/24",
  "10.1.11.0/24",
  "10.1.12.0/24",
  "10.1.13.0/24",
  "10.1.14.0/24",
  "10.1.15.0/24",
  "10.1.16.0/24",
  "10.1.17.0/24",
  "10.1.18.0/24",
  "10.1.19.0/24",
  "10.1.20.0/24",
  "10.1.21.0/24",
  "10.1.22.0/24",
  "10.1.23.0/24",
  "10.1.24.0/24",
  "10.1.25.0/24",
  "10.1.26.0/24",
  "10.1.27.0/24",
  "10.1.28.0/24",
  "10.1.29.0/24",
]
tenant_vcns_per_peering_vcn = [
  [
    "10.1.0.0/24",
    "10.1.1.0/24",
    "10.1.2.0/24",
    "10.1.3.0/24",
    "10.1.4.0/24",
    "10.1.5.0/24",
    "10.1.6.0/24",
    "10.1.7.0/24",
    "10.1.8.0/24",
    "10.1.9.0/24",
  ],
  [
    "10.1.10.0/24",
    "10.1.11.0/24",
    "10.1.12.0/24",
    "10.1.13.0/24",
    "10.1.14.0/24",
    "10.1.15.0/24",
    "10.1.16.0/24",
    "10.1.17.0/24",
    "10.1.18.0/24",
    "10.1.19.0/24",
  ],
  [
    "10.1.20.0/24",
    "10.1.21.0/24",
    "10.1.22.0/24",
    "10.1.23.0/24",
    "10.1.24.0/24",
    "10.1.25.0/24",
    "10.1.26.0/24",
    "10.1.27.0/24",
    "10.1.28.0/24",
    "10.1.29.0/24",
  ],
]
```