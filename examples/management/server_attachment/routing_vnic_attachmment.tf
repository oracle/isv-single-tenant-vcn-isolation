# Configure the main netowrk including VPC, Subnet, Seclist
###### secondary routing vnic attachment for Peering VCN 1. ########
###
module routing_1_vnic_attachement {
  source = "../../../modules/routing_vnic_attachment"

  compartment_id = lookup(data.terraform_remote_state.management_network.outputs, "management_compartment_id", null)

  routing_instance_id       = lookup(data.terraform_remote_state.management_servers.outputs, "routing_id", null)
  peering_subnet_id         = lookup(data.terraform_remote_state.peering_network.outputs, "peering_1_subnet_id", null)
}

output routing_1_secondary_vnic_id {
  value = module.routing_1_vnic_attachement.routing_secondary_vnic_id
}

###### secondary routing vnic attachment for Peering VCN 2. ########
###
module routing_2_vnic_attachement {
  source = "../../../modules/routing_vnic_attachment"

  compartment_id = lookup(data.terraform_remote_state.management_network.outputs, "management_compartment_id", null)

  routing_instance_id       = lookup(data.terraform_remote_state.management_servers.outputs, "routing_id", null)
  peering_subnet_id         = lookup(data.terraform_remote_state.peering_network.outputs, "peering_2_subnet_id", null)
}

output routing_2_secondary_vnic_id {
  value = module.routing_2_vnic_attachement.routing_secondary_vnic_id
}

##########
########## IP Route Add ###########################
##########
module ip_route_add {
  source = "../../../modules/ip_route_add"

  compartment_id = lookup(data.terraform_remote_state.management_network.outputs, "management_compartment_id", null)

  bastion_ip                = lookup(data.terraform_remote_state.management_servers.outputs, "bastion_ip", null)
  routing_ip                = lookup(data.terraform_remote_state.management_servers.outputs, "routing_ip", null)
  peering_1_subnet_cidr       = lookup(data.terraform_remote_state.peering_network.outputs, "peering_1_subnet_cidr", null)
  tenant_1_vcn_cidr_block   = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_1_vcn_cidr", null)
  tenant_2_vcn_cidr_block   = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_2_vcn_cidr", null)
  peering_2_subnet_cidr       = lookup(data.terraform_remote_state.peering_network.outputs, "peering_2_subnet_cidr", null)
  tenant_3_vcn_cidr_block   = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_3_vcn_cidr", null)
  tenant_4_vcn_cidr_block   = lookup(data.terraform_remote_state.tenant_network.outputs, "tenant_4_vcn_cidr", null)

  peering_1_vnic_id         = "${module.routing_1_vnic_attachement.routing_secondary_vnic_id}"
  peering_2_vnic_id         = "${module.routing_2_vnic_attachement.routing_secondary_vnic_id}"
}

output ip_route_add_status {
  value = "IP Route Add successfull"
}