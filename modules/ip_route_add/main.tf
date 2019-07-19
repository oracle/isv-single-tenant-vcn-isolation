/*
IP Route addition for all tenants traffic to the routing instance
*/
resource null_resource ip_route_add {
  connection {
    type        = "ssh"
    host        = var.routing_ip
    user        = "opc"
    private_key = file(var.ssh_private_key_file)

    bastion_host        = var.bastion_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.bastion_ssh_private_key_file)
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
      "while [ \"$(curl --silent -L http://169.254.169.254/opc/v1/vnics | jq  -c '[ .[] | select(.vnicId | contains (\"${var.peering_1_vnic_id}\", \"${var.peering_1_vnic_id}\")) ] | length')\" != 2 ]",
      "do",
      "  echo waiting for interface to be ready",
      "  sleep 1",
      "done",
      "sudo ./secondary_vnic_all_configure.sh -c",
      "# IP FORWARDING",
      "echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/98-ip-forward.conf",
      "sudo sysctl -p /etc/sysctl.d/98-ip-forward.conf",
      "# add a route to the tenant network via the peer vnic",
      "sudo ip route add ${var.tenant_1_vcn_cidr_block} via ${cidrhost(var.peering_1_subnet_cidr, 1)}",
      "sudo ip route add ${var.tenant_2_vcn_cidr_block} via ${cidrhost(var.peering_1_subnet_cidr, 1)}",
      "sudo ip route add ${var.tenant_3_vcn_cidr_block} via ${cidrhost(var.peering_2_subnet_cidr, 1)}",
      "sudo ip route add ${var.tenant_4_vcn_cidr_block} via ${cidrhost(var.peering_2_subnet_cidr, 1)}",
      "sudo firewall-offline-cmd --add-masquerade",
      "sudo systemctl restart firewalld",
    ]
  }
}  