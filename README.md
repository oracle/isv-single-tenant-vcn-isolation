ISV Single-Tenant VCN Isolation solution
========================================

This solution provides a network architecture that isolates an ISV's customers in separate VCNs in a single OCI tenancy. It includes a central management network through which the ISV can connect to and manage all the customer environments.

*(placeholder for toc)*

## Terminology

* **SaaS ISV**: An independent software vendor that provides software as a service.
* **Tenancy**: An Oracle Cloud Infrastructure account, owned by an ISV.
* **Tenant**: A customer of the ISV.

## Architecture

The following diagram shows the target topology:

*(placeholder for diagram)*

### Management Layer
This layer in the topology includes the following resources:
-  **Bastion server**:	This server is deployed in a public subnet. It is used by the Terraform script to provision applications on the tenant VCNs. It can also be used to access resources in private subnets in the management VCN and the tenant VCNs.
-  **Monitoring server**: This server hosts a Nagios management server, which monitors all the applications deployed across the tenant VCNs.
-  **Gateway cluster**: The gateway is deployed with a Pacemaker/Corosync cluster. The cluster includes multiple virtual routers to provide high availability when there are issues with the configuration or the OS. The cluster uses a secondary IP address, which can *float* between two virtual routers. This enables high availability with minimal to zero downtime.

### Peering Network
The VCNs in this network serve as a bridge between the single management network and multiple tenant networks. A combination of local peering gateways (LPG) and VNIC attachments enables you to scale up the architecture. Each host in the gateway cluster has a secondary VNIC in the peering network VCNs, which, in turn, are peered through an LPG with the individual tenant VCNs. The instance shape of the gateway hosts dictates the maximum number of secondary VNICs that the architecture can support.

### Tenant Layer
This layer contains the following resources:
- **Tenant VCNs**: Each tenant (that is, the end customer of the ISV) is isolated in a separate VCN with no connectivity between the tenants. Each tenant VCN has backward connectivity to the ISV's management network.
- **Tenant server**: A Nagios Remote Plugin Executor (NRPE) is installed on a server in each tenant VCN. The NRPE reports the health of the server to the Nagios monitoring server in the management layer. This installation is solely for the purpose of demonstrating the direct connectivity from the management network to the tenant networks with a scale-out architecture.


## Quickstart Deployment

1. Clone this repository to your local host. The `examples` directory contains the Terraform configurations for a sample topology based on the architecture described earlier. 
2. Install Terraform. See https://learn.hashicorp.com/terraform/getting-started/install.html.
3. Open `examples\terraform.tfvars` in a plain-text editor, and enter the values of the variables in that file.
4. In each subdirectory under the `examples` directory, run the command `terraform init`.
5. Deploy the topology:
    
You can deploy the entire topology with a single command by using `terragrunt`. Alternatively, deploy the configuration in each subdirectory using terraform.

*(placeholder: explain the value of deploying using Terraform, considering that Terragrunt provides a simpler flow)*

-   **Deploy Using Terraform**

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

-   **Deploy Using Terragrunt**

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