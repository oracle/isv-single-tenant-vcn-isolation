Full Solution Deployment Example
================================

This example provides a complete deployment of the tenant isolution solution.

The solution deployment is comprised of multiple terraform projects that are deployed in sequence to layer the network, server, and application provisioning of the management, peering, and tenant resources.

Terragrunt can optionally be used to apply all the Terraform configurations in the correct sequence

Copy `terraform.tfvars.sample` to `terraform.tfvars` and update with your environment specific details

```
$ terragrunt apply-all
```

