// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

/*
 * Create a single (non HA) routing instance used to route traffic between the management
 * and tenant peering networks 
 */

resource oci_core_instance routing_server {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = var.display_name
  hostname_label      = var.hostname_label

  source_details {
    source_type = "image"
    source_id   = var.source_id
  }

  shape = var.shape

  metadata = {
    ssh_authorized_keys = file(var.remote_ssh_public_key_file)
  }

  create_vnic_details {
    subnet_id              = var.subnet_id
    assign_public_ip       = false
    hostname_label         = var.hostname_label
    skip_source_dest_check = true
    nsg_ids                = var.peering_security_group_id_list
  }

  connection {
    type        = "ssh"
    host        = oci_core_instance.routing_server.private_ip
    user        = "opc"
    private_key = file(var.remote_ssh_private_key_file)

    bastion_host        = var.bastion_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.bastion_ssh_private_key_file)
  }
}

data "oci_core_private_ips" "routing_ip" {
  ip_address = oci_core_instance.routing_server.private_ip
  subnet_id  = var.subnet_id
} 