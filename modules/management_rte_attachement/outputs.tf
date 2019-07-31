output routing_id {
  description = "ocid of the new route table for the management subnet"
  value       = oci_core_route_table_attachment.management_route_table_attachment.id
}