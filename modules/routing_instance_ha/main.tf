
/*
TODO
[-] use secrets server to generate password?
*/

locals {
  oci_cli_install = [
    "curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh | bash -s -- --accept-all-defaults",
    "sudo ln ~/bin/oci /usr/local/bin/oci",
    "mkdir ~/.oci",
    "echo '[DEFAULT]' > ~/.oci/config",
    "echo 'tenancy=${var.tenancy_id}' >> ~/.oci/config",
    "echo 'region=${var.region}' >> ~/.oci/config",
    "chmod 600 ~/.oci/config",
  ]
}

data "oci_core_private_ips" "routing_server1_private_ip" {
  ip_address = oci_core_instance.routing_server1.create_vnic_details[0].private_ip
  subnet_id  = oci_core_instance.routing_server1.create_vnic_details[0].subnet_id
}

data "oci_core_private_ips" "routing_server2_private_ip" {
  ip_address = oci_core_instance.routing_server2.create_vnic_details[0].private_ip
  subnet_id  = oci_core_instance.routing_server2.create_vnic_details[0].subnet_id
}

resource "oci_core_private_ip" "floating_ip" {
  vnic_id        = data.oci_core_private_ips.routing_server1_private_ip.private_ips[0].vnic_id
  hostname_label = var.hostname_label

  lifecycle {
    ignore_changes = [
      # ignore changes to vnic_id as it can be moved dynamically for HA failover
      vnic_id,
    ]
  }
}

resource oci_core_instance routing_server1 {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = "${var.display_name} 1"

  source_details {
    source_type = "image"
    source_id   = var.source_id
  }

  shape        = var.shape
  fault_domain = data.oci_identity_fault_domains.fault_domains.fault_domains[0].name

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_file)
  }

  create_vnic_details {
    subnet_id              = var.subnet_id
    assign_public_ip       = false
    hostname_label         = "${var.hostname_label}1"
    skip_source_dest_check = true

    nsg_ids = [
      oci_core_network_security_group.pacemaker.id
    ]
  } 

  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = "opc"
    private_key = file(var.ssh_private_key_file)

    bastion_host        = var.bastion_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.bastion_ssh_private_key_file)
  }

  # install and configure oci cli tool
  provisioner remote-exec {
    inline = local.oci_cli_install
  }

  # install pacemaker
  provisioner remote-exec {
    inline = local.pacemaker_install
  }
}

resource oci_core_instance routing_server2 {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = "${var.display_name} 2"

  source_details {
    source_type = "image"
    source_id   = var.source_id
  }

  shape        = var.shape
  fault_domain = data.oci_identity_fault_domains.fault_domains.fault_domains[1].name

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_file)
  }

  create_vnic_details {
    subnet_id              = var.subnet_id
    assign_public_ip       = false
    hostname_label         = "${var.hostname_label}2"
    skip_source_dest_check = true

    nsg_ids = [
      oci_core_network_security_group.pacemaker.id
    ]
  }

  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = "opc"
    private_key = file(var.ssh_private_key_file)

    bastion_host        = var.bastion_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.bastion_ssh_private_key_file)
  }

  # install and configure oci cli tool
  provisioner remote-exec {
    inline = local.oci_cli_install
  }

  # install pacemaker
  provisioner remote-exec {
    inline = local.pacemaker_install
  }
}