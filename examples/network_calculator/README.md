Network Calculator Example
==========================

This example demonstrates the use of the [`network_calculator`](../../modules/network_calculator) module which can be used to generate consecutive tenant and peering network CIDRs groupings based on the a given set of parameters for the starting network addresses, network sizes, number of peered tenants per peering vcn, and the number of peering vcns per routing instance

This example can be run standalone and does not need a provider configuration

```
$ terraform apply
```