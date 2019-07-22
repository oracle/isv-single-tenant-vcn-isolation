output instance {
  value = oci_core_instance.routing_server
}

output routing_ip {
  value = oci_core_instance.routing_server.private_ip
}

output hostname_label {
  value = var.hostname_label
}
