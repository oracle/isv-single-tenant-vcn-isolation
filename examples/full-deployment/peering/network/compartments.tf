# Configure the main compartment
###
### Compartment for peering gateway 1 ##########################################
module peering_compartment {
  source = "../../../../modules/compartment"

  providers = {
    oci.home = "oci.home"
  }

  root_compartment_id = local.root_compartment_id
  compartment_name    = var.compartment_name
}

resource "oci_identity_dynamic_group" "routing" {
  provider       = "oci.home"
  compartment_id = var.tenancy_ocid # dynamic groups must be in the root compartment
  name           = "routing_instances"
  description    = "Dynamic Group for Routing Instance Principles"
  # include all instances in the peering compartment
  matching_rule = "ANY {instance.compartment.id = '${module.peering_compartment.compartment_id}'}"
}

resource "oci_identity_policy" "routing" {
  provider       = "oci.home"
  compartment_id = var.compartment_ocid # place in the parent compartment
  description    = "Policy for Routing Instance Principles"
  name           = "routing_instances"
  statements = [
    # only allow permission to modify vnics
    "Allow dynamic-group ${oci_identity_dynamic_group.routing.name} to use vnic in compartment ${var.compartment_name}"
  ]
}

output "peering_compartment_id" {
  value = module.peering_compartment.compartment_id
}

