// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output instance_ip {
  description = "ip address of the tenant application instance"
  value       = oci_core_instance.tenant_appserver.private_ip
}