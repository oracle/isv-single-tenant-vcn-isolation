output instance {
  value = oci_core_instance.routing_server
}

output routing_ip {
  value = data.oci_core_private_ips.routing_ip.private_ips[0]
}

output hostname_label {
  value = var.hostname_label
}
