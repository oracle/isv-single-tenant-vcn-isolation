output routing_secondary_vnic_id {
  description = "ocid of the vnic attachment"
  value       = oci_core_vnic_attachment.routing_vnic_attachmment.vnic_id
}