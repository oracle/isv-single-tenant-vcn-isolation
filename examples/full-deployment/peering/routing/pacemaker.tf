/* FIXME

locals {
  # TODO dynamically get the list of routing instances
  instances = [
    module.routing_instance_1.instance1.private_ip,
    module.routing_instance_1.instance2.private_ip,
    # module.routing_instance_2.instance1.private_ip,
    # module.routing_instance_2.instance2.private_ip,
  ]
}


module router_instance_1_pacemaker_config {
  source = "../../../../modules/pacemaker_config"
  hostname = ""
  instance1_primary_vnic_id = module.routing_instance_1.instance_vnics[0]
  instance1_secondary_vnic_id = module.routing_instance_1a_peering_1_vnic_attachement.routing_secondary_vnic_id
  instance2_primary_vnic_id = module.routing_instance_1.instance_vnics[1]
  instance2_secondary_vnic_id = module.routing_instance_1b_peering_1_vnic_attachement.routing_secondary_vnic_id
  floating_ip = module.routing_instance_1.floating_ip
  floating_secondary_ip = oci_core_private_ip.routing_instance_1_peering_1_floating_ip.ip_address
}


# configure the fail-over actions
resource null_resource pacemaker_config {
  # TODO use for_each?
  count = length(local.instances)

  triggers = {
  }

  connection {
    type        = "ssh"
    host        = local.instances[count.index]
    user        = "opc"
    private_key = file("~/.ssh/id_rsa") # TODO

    bastion_host        = local.bastion_ip
    bastion_user        = "opc"
    bastion_private_key = file("~/.ssh/id_rsa") #TODO
  }

  provisioner remote-exec {
    inline = module.router_instance_1_pacemaker_config.config
  }
}

*/