Set Up the Infrastructure to Run Multiple Single-Tenant SaaS Applications
=========================================================================

Use this Terraform configuration to create the necessary network resources to deploy multiple single-tenant applications that are isolated in separate VCNs.

## Architecture

placeholder for architecture diagram


## Example deployment

The `examples` directory contains multiple Terraform configurations that can be deployed separately to build up the complete example solution deployment.   

The complete solution can be deploy using `terragrunt` (see [Deploy with Terragruny)[#deploy-with-terragrunt]), or manually perform a Terraform init/plan/apply in each example directory in following order to layer the configuations.

1. Peering Network
	- `examples/peering/network`
2. Management Network and Servers
	- `examples/management/network`
	- `examples/management/servers`
3. Tenant Network and Servers
	- `examples/tenant/network`
	- `examples/management/server_attachment`
	- `examples/tenant/servers`
4. Applications
	- `examples/management/application`
	- `examples/tenant/application`


### Deploy with Terragrunt

`terragrunt` can be used deploy the complete configuration in a single command.  `terraform init` must have been run in each sub confguration first.

At single `terraform.tfvars` file can be created in the `examples` directory which will be applied to all configs.

```
$ cd examples
$ make init

$ terragrunt apply-all
```

To fully destroy the the deployed example

```
$ terragrunt destroy-all
```


## Testing

Automated tests are provided in the test directory, see [`test/README`](test/README.md) for details.