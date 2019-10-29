# Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
#
# Cookbook Name:: nagios-cookbook
# Recipe:: nagios server
# Author:: Sunil Bemarkar
# All rights reserved 
#

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