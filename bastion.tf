resource oci_core_instance bastion1 {
  availability_domain = local.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "bastion1"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oraclelinux.images.0.id
  }

  shape = "VM.Standard2.1"

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
  }

  create_vnic_details {
    subnet_id        = module.isv_vcn.access_subnet.id
    assign_public_ip = true
    hostname_label   = "bastion1"
  }

  connection {
    type        = "ssh"
    host        = oci_core_instance.bastion1.public_ip
    user        = "opc"
    private_key = file("~/.ssh/id_rsa")
  }

  # upload the SSH keys
  provisioner file {
    source      = "./.ssh/id_rsa"
    destination = ".ssh/id_rsa"
  }

  provisioner file {
    source      = "./.ssh/id_rsa.pub"
    destination = ".ssh/id_rsa.pub"
  }

  provisioner remote-exec {
    inline = [
      "chmod go-rwx .ssh/id_rsa",
    ]
  }
}

output bastion1 {
  value = oci_core_instance.bastion1.public_ip
}

