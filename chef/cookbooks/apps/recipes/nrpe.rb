#
# Cookbook Name:: nrpe-cookbook
# Recipe:: nagios remtoe client
# Author:: Sunil Bemarkar
# All rights reserved 
#

# install packages
['nagios', 'nagios-plugins-all', 'nrpe'].each do |pkg|
	package pkg do 
		action :install
	end
end

# open port for 5666 for nrpe service
execute 'firewalld_open_port_5666' do
  command 'firewall-cmd --zone=public --permanent --add-port=5666/tcp'
end

# update nrpe.cfg file with nagios server ip
execute 'allowed_hosts_nrpe_cfg' do
  command 'sed -i "s/.*allowed_hosts=.*/allowed_hosts=${host_ip}/" /etc/nagios/nrpe.cfg'
end

# enable & start service nrpe
service 'nrpe' do 
   action [ :enable, :start]
end