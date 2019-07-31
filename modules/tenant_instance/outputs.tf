output instance_ip {
  description = "ip address of the tenant application instance"
  value       = oci_core_instance.tenant_appserver.private_ip
}