resource oci_core_instance tenant_appserver {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = var.display_name 
  hostname_label      = var.hostname_label 

  source_details {
    source_type = "image"
    source_id   = var.source_id
  }

  shape = "VM.Standard2.1"

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
    user_data = "${base64encode(file("../../../scripts/nrpe_bootscript.sh"))}"
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = false
    hostname_label   = var.hostname_label
    private_ip       = var.tenant_private_ip
  }

  connection {
    type        = "ssh"
    host        = oci_core_instance.tenant_appserver.private_ip
    user        = "opc"
    private_key = file("~/.ssh/id_rsa")

    bastion_host        = var.bastion_ip
    bastion_user        = "opc"
    bastion_private_key = file("~/.ssh/id_rsa")
  }
}