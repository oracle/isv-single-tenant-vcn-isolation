# Configure the main compartment
module tenant_compartment {
  source = "../../../modules/compartment"

  providers = {
    oci.home = "oci.home"
  }

  root_compartment_id = local.root_compartment_id
  compartment_name    = var.compartment_name
}

output "tenant_compartment_id" {
  value = "${module.tenant_compartment.compartment_id}"
}