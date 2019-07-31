output instance_ip {
  description = "the public ip address of the bastion host instance"
  value       = oci_core_instance.bastion_server.public_ip
}