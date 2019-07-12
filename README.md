Steps: [ perform terraform init/plan/deploy in directories in following order]
	1.	Peering 
		a.	Network  -- cd examples/peering/network
	2.	Management
		a.	Network  -- cd examples/management/network
		b.	Servers	    -- cd examples/management/servers
	3.	Tenant
		a.	Network  -- cd examples/tenant/network
		b.	Servers    -- cd examples/tenant/servers