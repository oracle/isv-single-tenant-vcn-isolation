# Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
#
# Cookbook Name:: nagios-cookbook
# Recipe:: nagios server
# Author:: Sunil Bemarkar
# All rights reserved 
#

# install packages
['httpd', 'php', 'gcc', 'glibc', 'glibc-common', 'make', 'gd', 'gd-devel', 'net-snmp'].each do |pkg|
	package pkg do 
		action :install
	end
end

include_recipe 'apps::nagios_server'

# This is just for this tutorial, otherwise use the databag 
# to store this confidential info
execute 'setup user/passwd for nagiosadmin site' do 
	command 'sudo htpasswd -c -db /usr/local/nagios/etc/htpasswd.users nagiosadmin ${nagios_pw}'
	action :run
end

include_recipe 'apps::httpd_setup'

include_recipe 'apps::nagios_plugin'

#ensure that nagios starts at boot time
execute 'ensure that nagios starts at boot time' do 
	command '/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg'
	action :run
end

##add the service to run nagios on boot.
execute 'add nagios service' do 
	command 'chkconfig nagios on'
	action :run
end

include_recipe 'apps::nagios_client_monitoring'

service 'nagios' do 
	action [ :enable, :restart]
end
