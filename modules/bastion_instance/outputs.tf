output instance_ip {
  value = oci_core_instance.bastion_server.public_ip
}