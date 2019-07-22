variable hostname {}
variable instance_a_primary_vnic_id {} // module.routing_instance.instance_vnics[0]
variable instance_a_secondary_vnic_id {} // module.routing_vnic_attachement1.routing_secondary_vnic_id
variable instance_b_primary_vnic_id {} // module.routing_instance.instance_vnics[1]
variable instance_b_secondary_vnic_id {} // module.routing_vnic_attachement2.routing_secondary_vnic_id
variable floating_ip {} // module.routing_instance.floating_ip
variable floating_secondary_ip {} // oci_core_private_ip.floating_peering_ip.ip_address


locals {
  pacemaker_config = [
    # TODO there is probably a cleaner way to do this, may need to create a standalone config file.
    # this and error prone if the source file changes and doesn't support config changes
    # 
    # inserts the following to `/usr/lib/ocf/resource.d/heartbeat/IPaddr2` starting at line 64
    "sudo sed -i '64i\\##### OCI vNIC variables\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '65i\\server=\"`${var.hostname} -s`\"\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '66i\\vrouter1vnic=\"${var.instance_a_primary_vnic_id}\"\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '67i\\vrouter1vnicpod1=\"${var.instance_a_secondary_vnic_id}\"\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '68i\\vrouter2vnic=\"${var.instance_b_primary_vnic_id}\"\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '69i\\vrouter2vnicpod1=\"${var.instance_b_secondary_vnic_id}\"\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '70i\\vnicip=\"${var.floating_ip}\"\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '71i\\vnicippod1=\"${var.floating_secondary_ip}\"\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",

    "sudo sed -i '614i\\##### OCI/IPaddr Integration\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '615i\\        if [ $server = \"${var.hostname}a\" ]; then\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '616i\\                /root/bin/oci network vnic assign-private-ip --unassign-if-already-assigned --vnic-id $vrouter1vnic  --ip-address $vnicip --auth instance_principal\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '617i\\                /root/bin/oci network vnic assign-private-ip --unassign-if-already-assigned --vnic-id $vrouter1vnicpod1  --ip-address $vnicippod1 --auth instance_principal\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '618i\\        else \\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '619i\\                /root/bin/oci network vnic assign-private-ip --unassign-if-already-assigned --vnic-id $vrouter2vnic  --ip-address $vnicip --auth instance_principal\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '620i\\                /root/bin/oci network vnic assign-private-ip --unassign-if-already-assigned --vnic-id $vrouter2vnicpod1  --ip-address $vnicippod1 --auth instance_principal\\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
    "sudo sed -i '621i\\        fi \\' /usr/lib/ocf/resource.d/heartbeat/IPaddr2",
  ]
}

output config {
  value = local.pacemaker_config
}