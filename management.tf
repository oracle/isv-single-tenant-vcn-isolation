resource oci_core_instance management1 {
  availability_domain = local.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "management1"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oraclelinux.images.0.id
  }

  shape = "VM.Standard2.1"

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
    user_data = "${base64encode(file("./nagios_bootscript.sh"))}"
  }

  create_vnic_details {
    subnet_id        = module.isv_vcn.management_subnet.id
    assign_public_ip = false
    hostname_label   = "management1"
  }

  connection {
    type        = "ssh"
    host        = oci_core_instance.management1.private_ip
    user        = "opc"
    private_key = file("~/.ssh/id_rsa")

    bastion_host        = oci_core_instance.bastion1.public_ip
    bastion_user        = "opc"
    bastion_private_key = file("~/.ssh/id_rsa")
  }

  # upload the SSH keys
  provisioner file {
    source      = "~/.ssh/id_rsa"
    destination = ".ssh/id_rsa"
  }

  provisioner file {
    source      = "~/.ssh/id_rsa.pub"
    destination = ".ssh/id_rsa.pub"
  }

  provisioner remote-exec {
    inline = [
      "chmod go-rwx .ssh/id_rsa",
    ]
  }

  #upload nagios file 
  provisioner file {
    source      = "./nagios_bootscript.sh"
    destination = "nagios_bootscript.sh"
  }

  #upload network setup file 
  provisioner file {
    source      = "./network_setup.sh"
    destination = "network_setup.sh"
  }

  provisioner remote-exec {
    inline = [
      "set -x",
      "# run the nagios installation script",
      "chmod a+x nagios_bootscript.sh",
      "chmod a+x network_setup.sh",
      "sudo ./network_setup.sh -c",
      "sudo ./nagios_bootscript.sh -c",   
    ]
  }
}

output management1 {
  value = oci_core_instance.management1.private_ip
}

