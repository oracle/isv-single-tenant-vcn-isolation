ISV Single-Tenant VCN Isolation solution
========================================

This solution provides a network architecture that isolates an ISV's customers in separate VCNs in a single OCI tenancy. It includes a central management network through which the ISV can connect to and manage all the customer environments.

## Terminology

* **SaaS ISV**: An independent software vendor that provides software as a service.
* **Tenancy**: An Oracle Cloud Infrastructure account, owned by an ISV.
* **Tenant**: A customer of the ISV.

## Architecture

The following diagram shows the target topology:

![architecture diagram](saas-isv-multitenant-architecture-derivative2.png "Architecture diagram")

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

3. Open `examples/full-deployment/terraform.tfvars` in a plain-text editor, and enter the values of the variables in that file.

4. Set the deployment passwords and shared secrets.  The full deployment examples requires variables to be set for the shared secret for the routing HA cluster, and an initial Nagios administrator password. These can be set using environment variables, or added to the `terraform.tfvars` files in the `full-deployment/peering/routing` and `full-deployment/management/application` configurartion directories respectively. e.g.

	```
	$ export TF_VAR_hacluster_password="P@55_Word"
	$ export TF_VAR_nagios_administrator_password="P@55_Word"
	```

5. Deploy the topology:

You can deploy the entire topology with a single command by using [Terragrunt](https://github.com/gruntwork-io/terragrunt). Alternatively, deploy the configuration in each subdirectory using Terraform.

*(placeholder: explain the value of deploying using Terraform, considering that Terragrunt provides a simpler flow)*

-   **Deploy Using Terraform**

	1. Copy the `examples/full-deployment/terraform.tfvars` into each Terraform configuration sub directory.
	2. Go to the `full-deployment/common/configuration` directory.
	3. Run the following commands:
    	```
    	terraform init
    	terraform plan
    	terraform apply
    	```
	4. Run the `terraform init`, `terraform plan`, and `terraform apply` commands in the following directories, in the given order:
		- `examples/full-deployment/common/compartments`
    	- `examples/full-deployment/peering/network`
    	- `examples/full-deployment/management/network`
    	- `examples/full-deployment/tenant/network`
    	- `examples/full-deployment/management/access`
    	- `examples/full-deployment/peering/routing`
    	- `examples/full-deployment/management/servers`
    	- `examples/full-deployment/management/server_attachment`
        - `examples/full-deployment/tenant/servers`    	
        - `examples/full-deployment/management/application` (optional, to deploy example Nagios installation)
    	- `examples/full-deployment/tenant/application` (optional, to deploy example app and Nagios agents)

-   **Deploy Using Terragrunt**

	1. Install Terragrunt. See https://github.com/gruntwork-io/terragrunt#install-terragrunt.
	2. Go to the `examples/full-deployment` directory, and run the following commands:

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

The entire topology, when deployed, can be tested by either executing the tests or through the Nagios management server. 

After logging in to the Nagios management server, you can navigate to the Nagios management portal and verify that all the provisioned tenant servers exist and are in a healthy state.

## Troubleshooting

### Cleaning up after a failed or partial deployment

If the full deployment of the solution fails due to an error and you want to un-deploy the partially provisioned configuration, the `terragrunt destroy-all` option can return the following error:

```
Error: Unsupported attribute

  on management_rte_attachment.tf line 8, in module "management_rte_attachement":
   8:     data.terraform_remote_state.peering_servers.outputs.routing_instance_1_ip_id,
    |----------------
    | data.terraform_remote_state.peering_servers.outputs is object with 3 attributes

This object does not have an attribute named "routing_instance_1_ip_id".
```

If this error occurs, run `terraform destroy` manually in each configuration directory in the reverse order of the directories listed in the **Deploy Using Terraform** section.

## Solutions Overview

This solution is logically partitioned in 3 networks such as Management, Peering & Tenant network to showcase the architecture demonstration of single tenant application deployment in multitenant environment.

### Network setup

1. **Management Network**
	This partition helps provide a single pane of window to manage the access, deployment, and maintenance of the complete topology.

	1.1 **Bastion**
	This server enables you to connect to the other resources in ISV tenancy.
	-	The server is a compute instance running an Oracle Linux image and deployed in a public subnet.
	-	This server is the only point of ingress to the resources in the ISV tenancy from the public internet.
	-	To connect to the bastion server, run: `ssh -i keypair.pem opc@bastion_ip`

	1.2 ****Management Server**** 
	This server runs the monitoring application Nagios. It is configured to listen to all the servers deployed in the tenant VCNs.
	-	The server is a compute instance running an Oracle Linux image and deployed in a private subnet
	-	Nagios v4.3.4 is installed on this server.
	-	It is configured with IP  addresses of all the servers deployed in the tenant VCNs.
	-	After deploying the topology, you can access the Nagios monitoring application through an SSH tunnel to the bastion server.
	    -	To create the tunnel, run: `ssh -L 80:management_host_ip:80 -i bastion_key.pem opc@bastion_host_ip` 
	    -	To access the management portal, browse to `http://localhost/nagios`
	        user_id: `nagiosadmin`
	        password: The password that you set using the `TF_VAR_nagios_administrator_password` variable.


	1.3 **Routing Server's**
	These servers route traffic between the ISV VCN and the tenant VCNs.
	-   The server is a compute instance running an Oracle Linux image and deployed in a private subnet
	-	PACEMAKER/Corosync is installed, and can be used for failover across an HA pair of routing servers.
	-	The secondary VNIC deployed in a peering VCN to establish connectivity through ther LPG with the tenant VCNs.
	-	The `secondary_vnic_all_configure.sh` script is used to attach the secondary VNIC. To make the VNIC attachment persistent, the `/etc/sysconfig/network-scripts/ifcfg-ens5` file is created.
	-	The required routes to the tenant VCNs are set up on this server.
	-	To ensure that the routes persist across reboots, the `/etc/sysconfig/network-scripts/route-ens5` file is created.
	-	The number of secondary VNICs that can be created is based on the shape of the instance. Larger shapes support more secondary VNICs.

2. **Peering Network**
This partition provides bridges, in the form of secondary VNICs, to the routing servers in the management network for achieving the "fan-out" architecture for peering the VCNs.

	2.1 **Secondary VNICs**
	-	LPGs are created in this VCN for peering with 10 different tenant VCNs.
	-	The CIDR block of this VCN can be correlated to the number of VNICs required to be created by the routing server in the peering subnet of the ISV VCN.
	
3. **Tenant Network**
	This partition has tenant resources to demonstrate the end-to-end connectivity of the architecture.

	3.1 **Tenant Network** (1-n) [VCNs, subnet, internet gateway, NAT gateway, LPG]

	3.2 **Tenant Servers** (1-n) [NRPE agent installed and configured with Nagios server's IP address to send monitoring metrics to]
	-	The server is a compute instance running an Oracle Linux image and deployed in a private subnet.
	-	The NRPE (Nagios remote agent) is deployed on this server, and it listens on port 5666.
	-	The NRPE configuration is updated with the IP address of the Nagios management server deployed in the management subnet of the ISV VCN.


## Routing Instance Configuration 

1. Enable IP forwarding in the kernel, and ensure that the configuration is persistent upon reboots on both router instances by adding the following to `/etc/sysctl.d/98-ip-forward.conf`:

	```
	net.ipv4.ip_forward=1
	```

2. Attach secondary VNICs with `skip source/destination` selected. To ensure that the vNIC attachment is maintained after reboot, create a configuration file for each VNIC.

	Example: `/etc/sysconfig/network-scripts/ifcfg-ens5` on Router 1

	```
	DEVICE=ens5
	BOOTPROTO=static
	IPADDR=10.253.0.2
	NETMASK=255.255.255.248
	ONBOOT=yes
	```

	Example: `/etc/sysconfig/network-scripts/ifcfg-ens5` on Router 2

	```
	DEVICE=ens5
	BOOTPROTO=static
	IPADDR=10.253.0.10
	NETMASK=255.255.255.248
	ONBOOT=yes
	```
3. Add static routes for each tenant VCN that can be accessed through the routing instance, pointing to the default gateway of the peering subnet that the tenant VCN is peered with.

	Router 1 configuration:

	```
	sudo ip route add 10.1.0.0/16 via 10.253.0.1 dev ens5
	sudo ip route add 10.2.0.0/16 via 10.253.0.1 dev ens5
	```

	Router 2 configuration:

	```
	sudo ip route add 10.3.0.0/16 via 10.253.0.9 dev ens5
	sudo ip route add 10.4.0.0/16 via 10.253.0.9 dev ens5
	```

4. Make sure that the attached routes persist upon reboot, by creating the following file for each VNIC:

	Example: `/etc/sysconfig/network-scripts/route-ens5` on Router 1

	```
	10.1.0.0/16 via 10.253.0.1
	10.2.0.0/16 via 10.253.0.1
	```

	Example: `/etc/sysconfig/network-scripts/route-ens5` on Router 2

	```
	10.3.0.0/16 via 10.253.0.9
	10.4.0.0/16 via 10.253.0.9
	```