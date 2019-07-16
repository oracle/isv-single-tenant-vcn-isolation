#!/usr/bin/env bash
echo "Start NRPE Installation !!"
echo
yum update -y
echo
yum -y install nagios nagios-plugins-all nrpe
echo
chkconfig nrpe on
echo
host_ip=`oci-metadata | grep nagios_server_ip | cut -d':' -f2 | xargs`
sed -i "s/.*allowed_hosts=.*/allowed_hosts=${host_ip}/" /etc/nagios/nrpe.cfg
echo
sudo firewall-offline-cmd --zone=public --add-port=5666/tcp
echo
systemctl start nrpe
echo
systemctl status nrpe
echo "NRPE Installation Completed!!"