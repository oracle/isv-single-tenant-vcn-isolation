# Configure the main compartment
module peering_compartment {
  source = "../../../modules/compartment"

  providers = {
    oci.home = "oci.home"
  }

  root_compartment_id	= local.root_compartment_id
  compartment_name		= var.compartment_name	
}

output "peering_compartment_id" {
  value = "${module.peering_compartment.compartment_id}"
}