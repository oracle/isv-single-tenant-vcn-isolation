/*
TODO For failover: If your target instance is terminated before you can move the secondary 
private IP to a standby, you must update the route rule to use the OCID of the new target 
private IP on the standby. The rule uses the target's OCID and not the private IP address
itself.
*/
resource oci_core_vnic_attachment routing_vnic_attachmment {
  instance_id = var.instance_id

  create_vnic_details {
    subnet_id      = var.subnet_id
    display_name   = var.display_name
    hostname_label = var.hostname_label

    assign_public_ip       = false
    skip_source_dest_check = true
  }

  connection {
    type        = "ssh"
    host        = var.ssh_host
    user        = "opc"
    private_key = file(var.ssh_private_key_file)

    bastion_host        = var.bastion_host
    bastion_user        = "opc"
    bastion_private_key = file(var.bastion_ssh_private_key_file)
  }

  provisioner remote-exec {
    inline = [
      "set -x",
      "# run the vnic configuration script",
      "curl -o secondary_vnic_all_configure.sh ${var.secondary_vnic_configuration_script_url}",
      "chmod a+x secondary_vnic_all_configure.sh",
      "while [ \"$(curl --silent -L http://169.254.169.254/opc/v1/vnics | jq '.[] | select(.vnicId==\"${self.vnic_id}\") != null')\" != \"true\" ]",
      "do",
      "  echo waiting for interface to be ready",
      "  sleep 1",
      "done",
      "sudo ./secondary_vnic_all_configure.sh -c",
      "# ENABLE IP FORWARDING",
      "echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/98-ip-forward.conf",
      "sudo sysctl -p /etc/sysctl.d/98-ip-forward.conf",
      "# ENABLE NAT",
      "sudo firewall-offline-cmd --add-masquerade",
      "sudo systemctl restart firewalld",
    ]
  }
}
