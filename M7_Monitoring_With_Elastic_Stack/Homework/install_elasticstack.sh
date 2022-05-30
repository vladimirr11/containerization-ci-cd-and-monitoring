#!/bin/bash

echo "* Download elasticsearch ..."
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.0-x86_64.rpm

echo "* Install elasticsearch ..."
sudo rpm -Uvh elasticsearch-*.rpm

echo "* Change Java heap size ..."
echo "-Xms4g" | sudo tee /etc/elasticsearch/jvm.options.d/jvm.options 
echo "-Xms4g" | sudo tee -a /etc/elasticsearch/jvm.options.d/jvm.options 

echo "* Download logstash ..."
wget https://artifacts.elastic.co/downloads/logstash/logstash-8.1.0-x86_64.rpm

echo "* Install logstash ..."
sudo rpm -Uvh logstash-*.rpm

echo "* Download kibana ..."
wget https://artifacts.elastic.co/downloads/kibana/kibana-8.1.0-x86_64.rpm

echo "* Install kibana ..."
sudo rpm -Uvh kibana-*.rpm

echo "* Adjust firewall ..."
sudo firewall-cmd --add-port 9200/tcp --permanent
sudo firewall-cmd --add-port 5601/tcp --permanent
sudo firewall-cmd --add-port 5044/tcp --permanent
sudo firewall-cmd --reload
