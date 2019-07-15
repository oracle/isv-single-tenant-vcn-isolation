/*
TODO
For failover: If your target instance is terminated before you can move the secondary private IP to a standby, you must update the route rule to use the OCID of the new target private IP on the standby. The rule uses the target's OCID and not the private IP address itself.
*/
resource oci_core_vnic_attachment routing_vnic_attachmment {
  instance_id  = var.routing_instance_id
  display_name = var.display_name

  create_vnic_details {
    subnet_id      = var.peering_subnet_id
    display_name   = var.display_name
    hostname_label = var.display_name

    assign_public_ip       = false
    skip_source_dest_check = true
  }

  connection {
    type        = "ssh"
    host        = var.routing_ip
    user        = "opc"
    private_key = file("~/.ssh/id_rsa")

    bastion_host        = var.bastion_ip
    bastion_user        = "opc"
    bastion_private_key = file("~/.ssh/id_rsa")
  }

  # see https://docs.cloud.oracle.com/iaas/Content/Network/Tasks/managingVNICs.htm
  provisioner file {
    source      = "../../../scripts/secondary_vnic_all_configure.sh"
    destination = "secondary_vnic_all_configure.sh"
  }

  # TODO need to dynamically add the ip routes per tenant vcn
  provisioner remote-exec {
    inline = [
      "set -x",
      "# run the vnic configuration script",
      "chmod a+x secondary_vnic_all_configure.sh",
      "while [ \"$(curl --silent -L http://169.254.169.254/opc/v1/vnics | jq '.[] | select(.vnicId==\"${self.vnic_id}\") != null')\" != \"true\" ]",
      "do",
      "  echo waiting for interface to be ready",
      "  sleep 1",
      "done",
      "sudo ./secondary_vnic_all_configure.sh -c",
      "# IP FORWARDING",
      "echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/98-ip-forward.conf",
      "sudo sysctl -p /etc/sysctl.d/98-ip-forward.conf",
      "# add a route to the tenant network via the peer vnic",
      "sudo ip route add ${var.tenant_one_vcn_cidr_block} via ${cidrhost(var.peering_subnet_cidr, 1)}",
      "sudo firewall-offline-cmd --add-masquerade",
      "sudo systemctl restart firewalld",
    ]
  }
}  