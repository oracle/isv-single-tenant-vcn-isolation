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

### Application Resources
(placeholder for the description of the application resources)

## Prepare to Deploy the Topology

1. Clone this repository to your local host. The `examples` directory contains the Terraform configurations for a sample topology based on the architecture described earlier. 
2. Install Terraform. See https://learn.hashicorp.com/terraform/getting-started/install.html.
3. Open `examples\terraform.tfvars` in a plain-text editor, and enter the values of the variables in that file.
4. In each subdirectory under the `examples` directory, run the command `terraform init`.

## Deploy the Topology

You can deploy the entire topology with a single command by using `terragrunt`. See [Deploy Using Terragrunt)[#deploy-with-terragrunt]. Alternatively, deploy the configuration in each subdirectory.

### Deploy Using Terraform

(placeholder: explain the pros and cons of either approach)

by running the Terraform `init`, `plan`, and `apply` commands in :

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

### Deploy Using Terragrunt

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

### Deploy Using Terraform
(placeholder)

## Test the Sample Topology

Automated tests are provided in the `test` directory. See [`test/README`](test/README.md).