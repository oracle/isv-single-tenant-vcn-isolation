
# Cookbook Name:: nagios-cookbook
# Recipe:: nagios server
# Author:: Sunil Bemarkar
# All rights reserved 
#

#configure nagios to monitor tenants
execute 'uncomment nagios server property in nagios.cfg' do 
	command 'sed -i "s@#cfg_dir=/usr/local/nagios/etc/servers@cfg_dir=/usr/local/nagios/etc/servers@" /usr/local/nagios/etc/nagios.cfg'
	action :run
end

###### update nagios config to monitor tenants
#
#create directory and set owner
directory "/usr/local/nagios/etc/servers" do
  	mode 0755
 	action :create
end

#create file
file "/usr/local/nagios/etc/servers/hosts.cfg" do
	mode 0755
  	action :create
end

#write tenant configuration to the client.cfg
execute 'tenant 1 nagios server property in nagios.cfg' do 
	command 'echo -e "define host {\n\tuse\t\tlinux-server\n\thost_name\tappserver1\n\talias\t\tappserver1\n\taddress\t\t$(cut -d\',\' -f1 <<<${tenant_host_ips})\n}" | sudo tee  /usr/local/nagios/etc/servers/hosts.cfg'
	action :run
end
execute 'tenant 2 nagios server property in nagios.cfg' do 
	command 'echo -e "define host {\n\tuse\t\tlinux-server\n\thost_name\tappserver2\n\talias\t\tappserver2\n\taddress\t\t$(cut -d\',\' -f2 <<<${tenant_host_ips})\n}" | sudo tee -a /usr/local/nagios/etc/servers/hosts.cfg'
	action :run
end
execute 'tenant 3 nagios server property in nagios.cfg' do 
	command 'echo -e "define host {\n\tuse\t\tlinux-server\n\thost_name\tappserver3\n\talias\t\tappserver3\n\taddress\t\t$(cut -d\',\' -f3 <<<${tenant_host_ips})\n}" | sudo tee -a /usr/local/nagios/etc/servers/hosts.cfg'
	action :run
end
execute 'tenant 4 nagios server property in nagios.cfg' do 
	command 'echo -e "define host {\n\tuse\t\tlinux-server\n\thost_name\tappserver4\n\talias\t\tappserver4\n\taddress\t\t$(cut -d\',\' -f4 <<<${tenant_host_ips})\n}" | sudo tee -a /usr/local/nagios/etc/servers/hosts.cfg'
action :run
end