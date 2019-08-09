// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output vcn {
  description = "the `oci_core_vcn` resource"
  value       = oci_core_vcn.isv_vcn
}

output management_subnet {
  description = "the management subnet `oci_core_subnet` resource"
  value       = oci_core_subnet.management_subnet
}

output access_subnet {
  description = "the access subnet `oci_core_subnet` resource"
  value       = oci_core_subnet.access_subnet
}

output peering_subnet {
  description = "the peering subnet `oci_core_subnet` resource"
  value       = oci_core_subnet.peering_subnet
}

output peering_network_security_group {
  description = "the peering security group `oci_core_network_security_group` resource"
  value       = oci_core_network_security_group.peering_network_security_group
}

output nat_id {
  description = "ocid of the nat gateway"
  value       = oci_core_nat_gateway.management_nat.id
}

output igw_id {
  description = "ocid of the internet gateway"
  value       = oci_core_internet_gateway.management_igw.id
}

output icmp_security_group {
  description = "peering security group `oci_core_network_security_group` resource"
  value       = oci_core_network_security_group.icmp_network_security_group
}

output http_security_group {
  description = "peering security group `oci_core_network_security_group` resource"
  value       = oci_core_network_security_group.http_network_security_group
}