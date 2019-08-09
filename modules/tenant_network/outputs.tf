// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output tenant_vcn {
  description = "tenant vcn `oci_core_vcn` resource"
  value       = oci_core_vcn.tenant_vcn
}

output tenant_private_subnet {
  description = "tenant private subnet `oci_core_subnet` resource"
  value       = oci_core_subnet.private_subnet
}

output tenant_public_subnet {
  description = "tenant public subnet `oci_core_subnet` resource"
  value       = oci_core_subnet.public_subnet
}

output tenant_nrpe_security_group {
  description = "tenant security group `oci_core_network_security_group` resource"
  value       = oci_core_network_security_group.nrpe_network_security_group
}
