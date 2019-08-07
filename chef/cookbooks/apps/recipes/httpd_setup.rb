# Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# add http service to firewalld
execute 'firewalld_add_http' do
  command 'firewall-cmd --zone=public --permanent --add-service=http'
end

#health check for backend server thru load balancer
file '/var/www/html/index.html' do
  content '<html>This is a placeholder for the home page.</html>'
  mode '0755'
  owner 'nagios'
  group 'nagcmd'
end

#start httpd service
service 'httpd' do
  action [ :enable, :restart]
end

execute 'firewalld_restart' do
  command 'systemctl restart firewalld'
end