resource oci_core_instance gateway1 {
  availability_domain = local.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "gateway1"
  hostname_label      = "gateway1"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oraclelinux.images.0.id
  }

  shape = "VM.Standard2.1"

  metadata = {
    ssh_authorized_keys = file("./.ssh/id_rsa.pub")
  }

  create_vnic_details {
    subnet_id        = module.isv_vcn.peering_subnet.id
    assign_public_ip = false
    hostname_label   = "gateway1"
  }

  connection {
    type        = "ssh"
    host        = oci_core_instance.gateway1.private_ip
    user        = "opc"
    private_key = file("./.ssh/id_rsa")

    bastion_host        = oci_core_instance.bastion1.public_ip
    bastion_user        = "opc"
    bastion_private_key = file("~/.ssh/id_rsa")
  }

  # upload the SSH keys
  provisioner file {
    source      = "./.ssh/id_rsa"
    destination = ".ssh/id_rsa"
  }

  provisioner file {
    source      = "./.ssh/id_rsa.pub"
    destination = ".ssh/id_rsa.pub"
  }

  provisioner remote-exec {
    inline = [
      "chmod go-rwx .ssh/id_rsa",
    ]
  }
}

/*
TODO
For failover: If your target instance is terminated before you can move the secondary private IP to a standby, 
you must update the route rule to use the OCID of the new target private IP on the standby. The rule uses the 
target's OCID and not the private IP address itself.
*/

resource oci_core_vnic_attachment peer1 {
  instance_id  = oci_core_instance.gateway1.id
  display_name = "gw1peer1"

  create_vnic_details {
    subnet_id      = module.tenant_peering_vcn.subnet.id
    display_name   = "gw1peer1"
    hostname_label = "gw1peer1"

    assign_public_ip       = false
    skip_source_dest_check = true
  }

  connection {
    type        = "ssh"
    host        = oci_core_instance.gateway1.private_ip
    user        = "opc"
    private_key = file("./.ssh/id_rsa")

    bastion_host        = oci_core_instance.bastion1.public_ip
    bastion_user        = "opc"
    bastion_private_key = file("~/.ssh/id_rsa")
  }

  # see https://docs.cloud.oracle.com/iaas/Content/Network/Tasks/managingVNICs.htm
  provisioner file {
    source      = "./secondary_vnic_all_configure.sh"
    destination = "secondary_vnic_all_configure.sh"
  }

  # TODO need to dynamically add the ip routes per tenant vcn
  provisioner remote-exec {
    inline = [
      "set -x",
      "# run the vnic configuration script",
      "chmod a+x secondary_vnic_all_configure.sh",
      "sudo ./secondary_vnic_all_configure.sh -c",
      "# add a route to the tenant network via the peer vnic",
      "sudo ip route add ${module.tenant_one.vcn.cidr_block} via ${self.create_vnic_details[0].private_ip}",
      "sudo ip route add ${module.tenant_two.vcn.cidr_block} via ${self.create_vnic_details[0].private_ip}",
    ]
  }
}

output gateway1 {
  value = oci_core_instance.gateway1.private_ip
}