output instance {
  value = oci_core_instance.routing_server_a
}

output instance_a {
  value = oci_core_instance.routing_server_a
}

output instance_b {
  value = oci_core_instance.routing_server_b
}

output routing_ip {
  value = oci_core_private_ip.floating_ip
}

output instance_vnics {
  value = [
    data.oci_core_private_ips.routing_server_a_private_ip.private_ips[0].vnic_id,
    data.oci_core_private_ips.routing_server_b_private_ip.private_ips[0].vnic_id,
  ]
}

output hostname_label {
  value = var.hostname_label
}
