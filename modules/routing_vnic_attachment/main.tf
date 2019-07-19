/*
TODO For failover: If your target instance is terminated before you can move the secondary 
private IP to a standby, you must update the route rule to use the OCID of the new target 
private IP on the standby. The rule uses the target's OCID and not the private IP address
itself.
*/
resource oci_core_vnic_attachment routing_vnic_attachmment {
  instance_id  = var.routing_instance_id
  display_name = var.display_name

  create_vnic_details {
    subnet_id      = var.peering_subnet_id
    display_name   = var.display_name
    hostname_label = var.display_name

    assign_public_ip       = false
    skip_source_dest_check = true
  }
}