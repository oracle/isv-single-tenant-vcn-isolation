
# Routing Instance 1

module routing_instance_1_peering_1_vnic_attachement {
  source         = "../../../../modules/routing_vnic_attachment"
  hostname_label = "${module.routing_instance_1.instance.hostname_label}"
  display_name   = "${module.routing_instance_1.instance.hostname_label} peering interface 1"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance_1.instance.id
  subnet_id = data.terraform_remote_state.peering_network.outputs.peering_1_network.peering_subnet.id

  ssh_host     = module.routing_instance_1.instance.private_ip
  bastion_host = local.bastion_ip
}

/* FIXME
module routing_instance_1b_peering_1_vnic_attachement {
  source         = "../../../../modules/routing_vnic_attachment"
  hostname_label = "${module.routing_instance_1.instance_b.hostname_label}"
  display_name   = "${module.routing_instance_1.instance_b.hostname_label} peering interface 1"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance_1.instance_b.id
  subnet_id = data.terraform_remote_state.peering_network.outputs.peering_1_network.peering_subnet.id 

  ssh_host     = module.routing_instance_1.instance_b.private_ip
  bastion_host = local.bastion_ip
}

resource oci_core_private_ip routing_instance_1_peering_1_floating_ip {
  vnic_id        = module.routing_instance_1a_peering_1_vnic_attachement.routing_secondary_vnic_id
  hostname_label = "gateway1"

  lifecycle {
    ignore_changes = [
      # ignore changes to vnic_id as it can be moved dynamically for HA failover
      vnic_id,
    ]
  }
}
*/

# TODO disabled additional interface
#  - using VM.Standard2.1 shape for testing with just one secondary vnic
/*
module routing_instance_1_peering_2_vnic_attachement {
  source         = "../../../../modules/routing_vnic_attachment"
  hostname_label = "${module.routing_instance_1.instance1.hostname_label}"
  display_name   = "${module.routing_instance_1.instance1.hostname_label} peering interface 2"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance_1.instance1.id
  subnet_id = data.terraform_remote_state.peering_network.outputs.peering_2_network.peering_subnet.id 

  ssh_host     = module.routing_instance_1.instance1.private_ip
  bastion_host = local.bastion_ip
}

module routing_instance_1b_peering_2_vnic_attachement {
  source         = "../../../../modules/routing_vnic_attachment"
  hostname_label = "${module.routing_instance_2.instance_a.hostname_label}"
  display_name   = "${module.routing_instance_2.instance_a.hostname_label} peering interface 2"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance_1.instance1.id
  subnet_id = data.terraform_remote_state.peering_network.outputs.peering_2_network.peering_subnet.id 

  ssh_host     = module.routing_instance_1.instance1.private_ip
  bastion_host = local.bastion_ip
}

resource oci_core_private_ip routing_instance_1_peering_2_floating_ip {
  vnic_id        = module.routing_instance_1a_peering_2_vnic_attachement.routing_secondary_vnic_id
  hostname_label = module.routing_instance_1a_peering_2_vnic_attachement.hostname_label

  lifecycle {
    ignore_changes = [
      # ignore changes to vnic_id as it can be moved dynamically for HA failover
      vnic_id,
    ]
  }
}
*/


# Routing Instance 2

module routing_instance_2_peering_1_vnic_attachement {
  source         = "../../../../modules/routing_vnic_attachment"
  hostname_label = "${module.routing_instance_2.instance.hostname_label}"
  display_name   = "${module.routing_instance_2.instance.hostname_label} peering interface 1"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance_2.instance.id
  subnet_id = data.terraform_remote_state.peering_network.outputs.peering_2_network.peering_subnet.id

  ssh_host     = module.routing_instance_2.instance.private_ip
  bastion_host = local.bastion_ip
}

/* FIXME
module routing_instance_2b_peering_1_vnic_attachement {
  source         = "../../../../modules/routing_vnic_attachment"
  hostname_label = "${module.routing_instance_2.instance_b.hostname_label}"
  display_name   = "${module.routing_instance_2.instance_b.hostname_label} peering interface 1"
  compartment_id = local.compartment_id

  instance_id = module.routing_instance_2.instance_b.id
  subnet_id = data.terraform_remote_state.peering_network.outputs.peering_2_network.peering_subnet.id

  ssh_host     = module.routing_instance_2.instance_b.private_ip
  bastion_host = local.bastion_ip
}

resource oci_core_private_ip routing_instance_2_peering_1_floating_ip {
  vnic_id        = module.routing_instance_2a_peering_1_vnic_attachement.routing_secondary_vnic_id
  hostname_label = "gateway2"

  lifecycle {
    ignore_changes = [
      # ignore changes to vnic_id as it can be moved dynamically for HA failover
      vnic_id,
    ]
  }
}
*/


