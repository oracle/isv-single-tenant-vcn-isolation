
provider oci {
  alias = "home"
}

/*
 * Create a compartment.
 */
resource oci_identity_compartment compartment {
  provider = oci.home

  compartment_id = var.root_compartment_id
  name           = var.compartment_name
  description    = "${var.compartment_name} compartment"
  enable_delete  = false
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}