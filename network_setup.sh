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
