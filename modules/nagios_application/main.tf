resource null_resource nagios_application {

  triggers = {
    management_host_ip = var.management_host_ip
  }

  connection {
    type        = "ssh"
    host        = var.management_host_ip
    user        = "opc"
    private_key = file(var.ssh_private_key_file)

    bastion_host        = var.bastion_host_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.bastion_ssh_private_key_file)
  }

  # upload the chef-solo scripts
  provisioner file {
    source      = "../../../chef"
    destination = "/home/opc"
  }

  provisioner remote-exec {
    inline = [
      "set -x",
      "curl -LO https://www.chef.io/chef/install.sh && sudo bash ./install.sh",
      "cd /home/opc/chef && pwd",
      "echo 'tenant_host_ips=${var.tenant_host_ips}' | sudo tee /etc/environment",
      "source /etc/environment",
      "sudo chef-solo -c /home/opc/chef/appserver.rb -j /home/opc/chef/nagios_server.json --chef-license accept",
    ]
  }
}