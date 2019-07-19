output instance1 {
  value = oci_core_instance.routing_server1
}

output instance2 {
  value = oci_core_instance.routing_server2
}

output floating_ip {
  value = oci_core_private_ip.floating_ip.ip_address
}

output instance_ids {
  value = [
    oci_core_instance.routing_server1.id,
    oci_core_instance.routing_server2.id,
  ]
}

output instance_vnics {
  value = [
    data.oci_core_private_ips.routing_server1_private_ip.private_ips[0].vnic_id,
    data.oci_core_private_ips.routing_server2_private_ip.private_ips[0].vnic_id,
  ]
}

output hostname_label {
  value = var.hostname_label
}
