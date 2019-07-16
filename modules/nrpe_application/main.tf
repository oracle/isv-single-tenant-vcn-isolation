resource null_resource nrpe_application {

  connection {
    type        = "ssh"
    host        = var.tenant_ip
    user        = "opc"
    private_key = file("~/.ssh/id_rsa")

    bastion_host        = var.bastion_host_ip
    bastion_user        = "opc"
    bastion_private_key = file("~/.ssh/id_rsa")
  }

  #upload the chef-solo binary
  provisioner file {
    source      = "../../../chef"
    destination = "/home/opc"
  }

  provisioner remote-exec {
    inline = [
      "set -x",
      "curl -LO https://www.chef.io/chef/install.sh && sudo bash ./install.sh",
      "cd /tmp/chef && pwd",
      "echo 'host_ip=${var.nagios_server_ip}' | sudo tee /etc/environment",
      "sudo source /etc/environment",
      "sudo chef-solo -c /home/opc/chef/appserver.rb -j /home/opc/chef/nrpe_client.json --chef-license accept",
    ]
  }
}