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