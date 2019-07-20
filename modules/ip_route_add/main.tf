/*
IP Route addition for all tenants traffic to the routing instance
*/
resource null_resource ip_route_add {

  triggers = {
    vnic_id = var.vnic_id
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

  # TODO need to dynamically add the ip routes per tenant vcn
  provisioner remote-exec {
    inline = [
      "set -x",
      "# add a route to the tenant network via the peer vnic",
      "sudo ip route add ${var.tenant_1_vcn_cidr_block} via ${cidrhost(var.peering_1_subnet_cidr, 1)}",
      "sudo ip route add ${var.tenant_2_vcn_cidr_block} via ${cidrhost(var.peering_1_subnet_cidr, 1)}",
      # "sudo ip route add ${var.tenant_3_vcn_cidr_block} via ${cidrhost(var.peering_2_subnet_cidr, 1)}",
      # "sudo ip route add ${var.tenant_4_vcn_cidr_block} via ${cidrhost(var.peering_2_subnet_cidr, 1)}",
    ]
  }
}  