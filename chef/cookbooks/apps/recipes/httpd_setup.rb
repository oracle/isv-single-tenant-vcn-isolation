# add http service to firewalld
execute 'firewalld_add_http' do
  command 'firewall-cmd --zone=public --add-service=http'
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