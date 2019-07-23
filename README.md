ISV Single-Tenant VCN Isolation solution
=========================================================================

This solution is a network architecture setup which isolates customer by VCN to create the isolation and segregation between customers. This allows ISV's management network to be able to establish connectivity & reach each customer VCN to accomplish a single pane of glass to manage all environments.

*(placeholder for toc)*

## Terminology

* **SaaS ISV**: An independent software vendor that provides software as a service.
* **Tenancy**: An Oracle Cloud Infrastructure account, owned by an ISV.
* **Tenant**: A distinct end-customer of the ISV.

## Architecture

The architecture consists of a scalable network topology, with a separate VCN for each tenant application, isolated in a tenant-specific compartment.

The following diagram shows the target topology:
*(placeholder for diagram)*

This topology consists of the following components:

### Management Network
*(placeholder for the description of the management network & servers)*
This includes 
	1>	Bastion server 		:	This server is deployed in public subnet and used by the terraform script to provision applications on the tenant VCN's and accessing resources in private subnets across the ISV Management VCN and Tenant VCN.
	2>  Management server 	: 	This server hosts a Nagios management server which monitors all the applications deployed across the tenant VCN's.
	3>	Gateway Cluster		:	Gateway is deployed with Pacemaker/Corosync cluster for high availability. For high availability this setup has more than one virtual router in case of a configuration or OS issue. Utilizes a Secondary IP which can "Float" between two virtual routers, which enables high availability cluster between hosts with very little to NO downtime.

### Peering Network
*(placeholder for the description of the peering network)*
	VCN's in this network acts as a bridge between ISV's management network fanning out across multiple tenant networks by utilizing a combination of Local Peering Gateways and VNIC attachments to achieve the scale the ISV is looking for instead of out of the box standard 1 to 10 peering connections. Hosts in Gateway cluster has a secondary VNIC in the peering network VCN's which in turn are peered thru LPG with individual tenant VCN's. Slight limitation to keep in mind is with instance shape of the gateway hosts which dictates the number of the secondary VNIC's that can be allowed eventually getting to the fan-out ratio.

### Tenant Network
*(placeholder for the description of the tenant network & servers)*
	Each tenant is isolated within it's separate VCN with no connectivity amongst the tenants and also backward connectivity to ISV's management network. This network includes
	1>	Tenant server 		:	Nagios Remote Plugin Executor is installed on each of the deployed servers in tenant VCN's which reports back the health to the nagios monitoring server in the management network. This installation is solely for the purpose of demonstrating the direct connectivity from the management network to the tenant networks with scale out architecture.


## Quickstart Deployment

1. Clone this repository to your local host. The `examples` directory contains the Terraform configurations for a sample topology based on the architecture described earlier. 
2. Install Terraform. See https://learn.hashicorp.com/terraform/getting-started/install.html.
3. Open `examples\terraform.tfvars` in a plain-text editor, and enter the values of the variables in that file.
4. In each subdirectory under the `examples` directory, run the command `terraform init`.
5. Deployment : You can deploy the entire topology with a single command by using `terragrunt`. See [Deploy Using Terragrunt](#deploy-using-terragrunt). Alternatively, deploy the configuration in each subdirectory using terraform.

	5.1. ### Deploy Using Terraform

		*(placeholder: explain the pros and cons of either approach)*

		1. Go to the `examples/peering/network` directory.
		2. Run the following commands:
		```
		terraform init
		terraform plan
		terraform apply
		```
		3. Run the `terraform init`, `terraform plan`, and `terraform apply` commands in the following directories, in the given order:
			- `examples/management/network`
			- `examples/management/servers`
			- `examples/tenant/network`
			- `examples/management/server_attachment`
			- `examples/tenant/servers`
			- `examples/management/application`
			- `examples/tenant/application`

	5.2. ### Deploy Using Terragrunt

		1. Install Terragrunt. See https://github.com/gruntwork-io/terragrunt#install-terragrunt.
		2. Go to the `examples` directory, and run the following commands:

		```
		make init
		terragrunt apply-all
		```
		All the resources defined in the configuration are deployed.
		3. (Optional) To remove all the resources, run the following command:
		```
		terragrunt destroy-all
```

## Test the Sample Topology

Automated tests are provided in the `test` directory. See [`test/README`](test/README.md).