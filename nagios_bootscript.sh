#!/usr/bin/env bash
echo "Network firewall setup"
sudo firewall-cmd --zone=public --permanent --list-services
echo
sudo firewall-cmd --zone=public --permanent --add-service=http
echo
sudo firewall-cmd --add-service=http
echo
sudo firewall-cmd --list-services
echo
systemctl status firewalld 
echo
echo
echo "Start NAGIOS Installation !!"
yum update -y
echo "YUM UPDATE Successfull !!!"
yum install -y httpd php
yum install -y gcc glibc glibc-common make gd gd-devel net-snm
useradd nagios
groupadd nagcmd
usermod -G nagcmd nagios
usermod -G nagcmd apache 
mkdir ~/nagios
chown -R nagios:nagcmd ~/nagios
cd ~/nagios
echo
wget https://sourceforge.net/projects/nagios/files/nagios-4.x/nagios-4.3.4/nagios-4.3.4.tar.gz/download
wget http://www.nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
echo
tar zxvf download
tar zxvf nagios-plugins-2.2.1.tar.gz
echo
echo "PWD == > "
pwd
cd nagios-4.3.4
echo "PWD < == "
pwd
echo
sleep 5
./configure --with-command-group=nagcmd
make all
make install

make install-init
make install-commandmode
make install-config
make install-webconf

sudo htpasswd -c -db /usr/local/nagios/etc/htpasswd.users nagiosadmin rasika

echo "NAGIOS Monitoring ..." > /var/www/html/index.html

echo "starting httpd service now"
systemctl start httpd.service

echo "Nagios installed sucesfully"

###### install Nagios Plugin now 
cd ../nagios-plugins-2.2.1
./configure --with-nagios-user=nagios --with-nagios-group=nagios

make
make install
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

chkconfig --add nagios
chkconfig --level 35 nagios on

###### update nagios config to monitor tenants
sudo sed -i "s@#cfg_dir=/usr/local/nagios/etc/servers@cfg_dir=/usr/local/nagios/etc/servers@" /usr/local/nagios/etc/nagios.cfg
echo
sudo mkdir /usr/local/nagios/etc/servers
echo
cd /usr/local/nagios/etc/servers
echo
sudo touch client.cfg
echo -e "define host {\n\tuse\t\tlinux-server\n\thost_name\tappserver1\n\talias\t\tappserver1\n\taddress\t\t${tenant_one_ip}\n}" | sudo tee  client.cfg
echo
systemctl start nagios.service
echo
echo "Nagios Plugin installed sucesfully"
echo
echo "Open the browser and enter the below link in it. Replace the "enteryouripaddress" part with the ip address and then hit enter."
echo "http:/enteryouripaddress/nagios"
echo
echo
