/*
IP Route addition for all tenants traffic to the routing instance
*/

locals {
  add_route_commands = var.peering_subnet_cidr == null ? [] : formatlist("sudo ip route add %s via ${cidrhost(var.peering_subnet_cidr, 1)}", var.tenant_vcn_cidrs)
}

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

  provisioner remote-exec {
    inline = flatten([[
      "set -x",
      "# add a route to the tenant network via the peer vnic",
    ], local.add_route_commands])
  }
}  