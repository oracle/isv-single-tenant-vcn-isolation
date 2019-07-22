Set Up the Infrastructure to Run Multiple Single-Tenant SaaS Applications
=========================================================================

Create the necessary network resources to deploy multiple single-tenant applications, isolated in separate VCNs in a single ISV-owned tenancy.

## Terminology

* **SaaS ISV**: An independent software vendor that provides software as a service.
* **Tenancy**: An Oracle Cloud Infrastructure account, owned by an ISV.
* **Tenant**: A distinct end-customer of the ISV.

## Architecture

The architecture consists of a scalable network topology, with a separate VCN for each tenant application, isolated in a tenant-specific compartment.

The following diagram shows the target topology:

(placeholder for diagram)

This topology consists of the following components:

### Peering Network
(placeholder for the description of the peering network)

### Management Infrastructure
(placeholder for the description of the management network & servers)

### Tenant Infrastructure
(placeholder for the description of the tenant network & servers)

### Application
(placeholder for the description of the application resources)

## Deploying the Sample Topology

The `examples` directory contains the Terraform configurations for a sample topology based on the architecture described earlier. 

You can build the entire solution by using `terragrunt` (see [Deploy Using Terragrunt)[#deploy-with-terragrunt]).

Alternatively, deploy the configuration in each subdirectory by running the Terraform `init`, `plan`, and `apply` commands in the following order:

1. Deploy the peering network.
	- `examples/peering/network`
2. Deploy the management network and servers.
	- `examples/management/network`
	- `examples/management/servers`
3. Deploy the tenant Network and Servers.
	- `examples/tenant/network`
	- `examples/management/server_attachment`
	- `examples/tenant/servers`
4. Deploy the applications.
	- `examples/management/application`
	- `examples/tenant/application`

### Deploy Using Terragrunt

You can use `terragrunt` to deploy the entire configuration with a single command.

1. Install Terraform. See https://learn.hashicorp.com/terraform/getting-started/install.html.
2. Install Terragrunt. See https://github.com/gruntwork-io/terragrunt#install-terragrunt.
3. Clone this repository to your local host.
4. Open `examples\terraform.tfvars` in a plain-text editor, and enter the values of the variables in that file.
5. In each subdirectory under the `examples` directory, run the command `terraform init`.
6. Go to the `examples` directory, and run the following commands:

```
make init
terragrunt apply-all
```
All the resources defined in the configuration are deployed.
7. (Optional) To remove all the resources, run the following command:
```
terragrunt destroy-all
```

### Deploy Using Terraform
(placeholder)

## Test the Sample Topology

Automated tests are provided in the `test` directory. See [`test/README`](test/README.md).