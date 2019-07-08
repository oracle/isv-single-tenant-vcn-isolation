resource oci_core_instance tenantone_appserver1 {
  availability_domain = local.availability_domain
  compartment_id      = module.tenant_one.compartment_id
  display_name        = "appserver1"
  hostname_label      = "appserver1"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oraclelinux.images.0.id
  }

  shape = "VM.Standard2.1"

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
    user_data = "${base64encode(file("./nrpe_bootscript.sh"))}"
  }

  extended_metadata = {
    nagios_server_ip = "${oci_core_instance.management1.private_ip}"
  }

  create_vnic_details {
    subnet_id        = module.tenant_one.private_subnet.id
    assign_public_ip = false
    hostname_label   = "appserver1"
  }

  #upload nrpe bootstrap file 
  #provisioner file {
  #  source      = "./nrpe_bootscript.sh"
  #  destination = "nrpe_bootscript.sh"
  #}

  #provisioner remote-exec {
  #  inline = [
  #    "set -x",
  #    "# run the nrpe installation script",
  #    "chmod a+x nrpe_bootscript.sh",
  #    "sudo ./nrpe_bootscript.sh -c ${oci_load_balancer.lb1.ip_addresses}",
  #  ]
  #}

}

output appserver1 {
  value = oci_core_instance.tenantone_appserver1.private_ip
}