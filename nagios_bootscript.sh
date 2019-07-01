#!/usr/bin/env bash
echo "Start NAGIOS Installation !!"
yum update -y
echo "YUM UPDATE Succesfull !!!"
yum install -y httpd php
yum install -y gcc glibc glibc-common make gd gd-devel net-snm
useradd nagios
groupadd nagcmd
usermod -G nagcmd nagios
usermod -G nagcmd apache 
mkdir ~/nagios
cd ~/nagios

wget https://sourceforge.net/projects/nagios/files/nagios-4.x/nagios-4.3.4/nagios-4.3.4.tar.gz/download
wget http://www.nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz

tar zxvf download
tar zxvf nagios-plugins-2.2.1.tar.gz

echo "PWD == > "
pwd
cd nagios-4.3.4
echo "PWD < == "
pwd

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

systemctl start nagios.service

echo "Nagios Plugin installed sucesfully"

echo "Open the browser and enter the below link in it. Replace the "enteryouripaddress" part with the ip address and then hit enter."
echo "http:/enteryouripaddress/nagios"











