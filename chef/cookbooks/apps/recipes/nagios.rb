#
# Cookbook Name:: nagios-cookbook
# Recipe:: nagios server
# Author:: Sunil Bemarkar
# All rights reserved 
#


# add http service to firewalld
execute 'firewalld_open_port_5666' do
  command 'firewall-cmd --zone=public --add-service=http'
end

# install packages
['httpd', 'php', 'gcc', 'glibc', 'glibc-common', 'make', 'gd', 'gd-devel', 'net-snmp'].each do |pkg|
	package pkg do 
		action :install
	end
end

#add user nagios
user 'nagios' do
	comment 'User Nagios'
end

#create group nagios and add user to this group and apache
group 'nagcmd' do
	comment 'Group Nagcmd'
	members ['nagios', 'apache']
end

#create directory and set owner
directory "/home/opc/nagios/" do
  mode 0755
  owner 'nagios'
  group 'nagcmd'
  action :create
end

####
# download remote file nagios-4.3.4.tar.gz
remote_file '/home/opc/nagios/nagios-4.3.4.tar.gz' do
  source 'https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.3.4.tar.gz'
  owner 'nagios'
  group 'nagcmd'
  mode '0755'
  action :create_if_missing
end
unless Dir.exists?('/home/opc/nagios/nagios-4.3.4')

	execute 'Extract nagios-4.3.4.tar.gz' do 
		cwd '/home/opc/nagios'
		command 'tar xvf nagios-4.3.4.tar.gz'
		action :run
	end

	execute 'Before building, configure it' do 
		cwd '/home/opc/nagios/nagios-4.3.4'
		command './configure --with-command-group=nagcmd'
		action :run
	end

	execute 'Compile it' do 
		cwd '/home/opc/nagios/nagios-4.3.4'
		command 'make all'
		action :run
	end

	execute 'Install nagios' do 
		cwd '/home/opc/nagios/nagios-4.3.4'
		command 'make install && make install-commandmode'
		action :run
	end
	execute 'Install init script' do 
		cwd '/home/opc/nagios/nagios-4.3.4'
		command 'make install-init'
		action :run
	end
	execute 'Install configs' do 
		cwd '/home/opc/nagios/nagios-4.3.4'
		command 'make install-config && make install-webconf'
		action :run
	end
end
# This is just for this tutorial, otherwise use the databag 
# to store this confidential info
execute 'setup user/passwd for nagiosadmin site' do 
	command 'sudo htpasswd -c -db /usr/local/nagios/etc/htpasswd.users nagiosadmin rasika'
	action :run
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

####
# download remote file nagios-plugins-2.2.1.tar.gz
remote_file '/home/opc/nagios/nagios-plugins-2.2.1.tar.gz' do
  source 'http://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz'
  owner 'nagios'
  group 'nagcmd'
  mode '0755'
  action :create_if_missing
end
unless Dir.exists?('/home/opc/nagios/nagios-plugins-2.2.1')

	execute 'Extract nagios-plugins-2.2.1.tar.gz' do 
		cwd '/home/opc/nagios'
		command 'tar xvf nagios-plugins-*.tar.gz'
		action :run
	end

	execute 'Before building, configure it' do 
		cwd '/home/opc/nagios/nagios-plugins-2.2.1'
		command './configure --with-nagios-user=nagios --with-nagios-group=nagcmd --with-openssl'
		action :run
	end

	execute 'Compile and install' do 
		cwd '/home/opc/nagios/nagios-plugins-2.2.1'
		command 'make'
		action :run
	end

	execute 'Compile and install' do 
		cwd '/home/opc/nagios/nagios-plugins-2.2.1'
		command 'make install'
		action :run
	end
end

#ensure that nagios starts at boot time
execute 'ensure that nagios starts at boot time' do 
	command '/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg'
	action :run
end

##add the service to run nagios on boot.
execute 'add nagios service' do 
	command 'chkconfig --add nagios && chkconfig --level 35 nagios on'
	action :run
end

execute 'check nagios service to run on boot time' do 
	command 'chkconfig --add nagios && chkconfig --level 35 nagios on'
	action :run
end

#configure nagios to monitor tenants
execute 'uncomment nagios server property in nagios.cfg' do 
	command 'sed -i "s@#cfg_dir=/usr/local/nagios/etc/servers@cfg_dir=/usr/local/nagios/etc/servers@" /usr/local/nagios/etc/nagios.cfg'
	action :run
end

###### update nagios config to monitor tenants
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

service 'nagios' do 
	action [ :enable, :restart]
end
