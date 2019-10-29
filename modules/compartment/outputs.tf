// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output compartment_id {
  value       = oci_identity_compartment.compartment.id
  description = "the ocid of the compartment"
}