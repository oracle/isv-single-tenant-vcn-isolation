output "lb_public_ip" {
  value = [oci_load_balancer.lb1.ip_addresses]
}