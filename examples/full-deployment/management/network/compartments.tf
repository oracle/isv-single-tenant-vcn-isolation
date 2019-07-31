/*
 * Configure the management compartment
 */

module management_compartment {
  source = "../../../../modules/compartment"

  providers = {
    oci.home = "oci.home"
  }

  root_compartment_id = local.root_compartment_id
  compartment_name    = var.compartment_name
}

output "management_compartment_id" {
  value = module.management_compartment.compartment_id
}