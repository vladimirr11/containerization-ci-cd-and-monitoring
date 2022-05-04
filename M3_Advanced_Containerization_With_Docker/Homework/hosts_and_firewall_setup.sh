#!/bin/bash

echo "* Add hosts ..."
echo "192.168.99.101 manager.do1.lab manager" >> /etc/hosts
echo "192.168.99.102 worker1.do1.lab worker1" >> /etc/hosts
echo "192.168.99.103 worker2.do1.lab worker2" >> /etc/hosts

echo "* Install Additional Packages ..."
dnf install -y jq tree git nano

echo "* Firewall - swarm - open ports ..."
firewall-cmd --add-port=2377/tcp --permanent
firewall-cmd --add-port=4789/udp --permanent
firewall-cmd --add-port=7946/tcp --permanent
firewall-cmd --add-port=7946/udp --permanent

echo "* Firewall - app - open port 8080 ..."
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload
