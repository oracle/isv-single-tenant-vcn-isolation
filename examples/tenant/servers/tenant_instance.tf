# Configure the main netowrk including VPC, Subnet, Seclist
module tenant_instance {
  source = "../../../modules/tenant_instance"

  providers = {
    oci.home = "oci.home"
  }

  compartment_id = 	lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_compartment_id", null)
  source_id		 	 = 	"${data.oci_core_images.oraclelinux.images.0.id}"
  subnet_id      =  lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_private_subnet_id", null)
  tenant_private_ip		=	  "192.168.2.2"
  availability_domain	=	  local.availability_domain
  bastion_ip     =  lookup(data.terraform_remote_state.mgmt_servers.outputs, "bastion_ip", null)
}

output "tenant_private_ip" {
  value = "${module.tenant_instance.instance_ip}"
}
