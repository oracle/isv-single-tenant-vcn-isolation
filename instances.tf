

resource oci_core_instance appserver1 {
  availability_domain = local.availability_domain
  compartment_id      = module.application_tenant.compartment_id
  display_name        = "appserver1"
  hostname_label      = "appserver1"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oraclelinux.images.0.id
  }

  shape = "VM.Standard2.1"

  metadata = {
    ssh_authorized_keys = file("./id_rsa.pub")
  }

  create_vnic_details {
    subnet_id        = module.application_tenant.private_subnet.id
    assign_public_ip = false
    hostname_label   = "appserver1"
  }

}

output appserver1 {
  value = oci_core_instance.appserver1.private_ip
}