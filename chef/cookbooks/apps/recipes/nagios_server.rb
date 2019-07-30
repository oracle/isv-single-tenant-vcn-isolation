#
# Cookbook Name:: nagios-cookbook
# Recipe:: nagios server
# Author:: Sunil Bemarkar
# All rights reserved 
#


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
# download remote file nagios-4.4.3.tar.gz
remote_file '/home/opc/nagios/nagios-4.4.3.tar.gz' do
  source 'https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.3.tar.gz'
  owner 'nagios'
  group 'nagcmd'
  mode '0755'
  action :create_if_missing
end
unless Dir.exists?('/home/opc/nagios/nagios-4.4.3')

	execute 'Extract nagios-4.4.3.tar.gz' do 
		cwd '/home/opc/nagios'
		command 'tar xvf nagios-4.4.3.tar.gz'
		action :run
	end

	execute 'Before building, configure it' do 
		cwd '/home/opc/nagios/nagios-4.4.3'
		command './configure --with-command-group=nagcmd'
		action :run
	end

	execute 'Compile it' do 
		cwd '/home/opc/nagios/nagios-4.4.3'
		command 'make all'
		action :run
	end

	execute 'Install nagios' do 
		cwd '/home/opc/nagios/nagios-4.4.3'
		command 'make install && make install-commandmode'
		action :run
	end
	execute 'Install init script' do 
		cwd '/home/opc/nagios/nagios-4.4.3'
		command 'make install-init'
		action :run
	end
	execute 'Install configs' do 
		cwd '/home/opc/nagios/nagios-4.4.3'
		command 'make install-config && make install-webconf'
		action :run
	end
end