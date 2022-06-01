#!/bin/bash

echo "* Download and extract node exporter ..."
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz 
tar xzvf node_exporter-1.3.1.linux-amd64.tar.gz
mv node_exporter-1.3.1.linux-amd64 node_exporter

echo "* Start node exporter in background mode ..."
cd node_exporter && ./node_exporter &> /tmp/node-exporter.log &

echo "* Adjust firewall ports ..."
firewall-cmd --add-port=9100/tcp --permanent
firewall-cmd --reload
