# Configure the main compartment
###
### Compartment for tenant 1 ##########################################
module tenant_1_compartment {
  source = "../../../../modules/compartment"

  providers = {
    oci.home = "oci.home"
  }

  root_compartment_id = local.root_compartment_id
  compartment_name    = "tenant1"
}

output "tenant_1_compartment_id" {
  value = module.tenant_1_compartment.compartment_id
}

###
### Compartment for tenant 2 ###########################################
module tenant_2_compartment {
  source = "../../../../modules/compartment"

  providers = {
    oci.home = "oci.home"
  }

  root_compartment_id = local.root_compartment_id
  compartment_name    = "tenant2"
}

output "tenant_2_compartment_id" {
  value = module.tenant_2_compartment.compartment_id
}

###
### Compartment for tenant 3 ###########################################
module tenant_3_compartment {
  source = "../../../../modules/compartment"

  providers = {
    oci.home = "oci.home"
  }

  root_compartment_id = local.root_compartment_id
  compartment_name    = "tenant3"
}

output "tenant_3_compartment_id" {
  value = module.tenant_3_compartment.compartment_id
}

###
### Compartment for tenant 4 ###########################################
module tenant_4_compartment {
  source = "../../../../modules/compartment"

  providers = {
    oci.home = "oci.home"
  }

  root_compartment_id = local.root_compartment_id
  compartment_name    = "tenant4"
}

output "tenant_4_compartment_id" {
  value = module.tenant_4_compartment.compartment_id
}