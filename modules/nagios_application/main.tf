resource null_resource nrpe_application {

  connection {
    type        = "ssh"
    host        = "10.254.254.2"
    user        = "opc"
    private_key = file("~/.ssh/id_rsa")

    bastion_host        = "130.35.226.11"
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
      "sudo chef-solo -c /home/opc/chef/appserver.rb -j /home/opc/chef/nagios_server.json --chef-license accept",
    ]
  }
}