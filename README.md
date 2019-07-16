Steps: [ perform terraform init/plan/deploy in directories in following order]
	1.	Peering 
		a.	Network  -- cd examples/peering/network
	2.	Management
		a.	Network  -- cd examples/management/network
		b.	Servers	    -- cd examples/management/servers
	3.	Tenant
		a.	Network  -- cd examples/tenant/network
		b.	Servers    -- cd examples/tenant/servers




## Deploy with Terragrunt

`terragrunt` can be used deploy the complete configuration in a single command.  `terraform init` must have been run in each sub confguration first.

At single `terraform.tfvars` file can be created in the `examples` directory which will be applied to all configs.

```
$ cd examples
$ (cd peering/network && terraform init)
$ (cd management/network && terraform init)
$ (cd management/servers && terraform init)
$ (cd tenant/network && terraform init)
$ (cd tenant/servers && terraform init)

$ terragrunt apply-all
```


## Testing

Automated tests are provided in the test directory, see [`test/README`](test/README.md) 