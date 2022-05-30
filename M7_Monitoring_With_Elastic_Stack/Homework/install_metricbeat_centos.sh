#!/bin/bash

echo "* Download metricbeat ..."
wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.1.0-x86_64.rpm

echo "* Install metricbeat ..."
sudo rpm -Uvh metricbeat-8.1.0-x86_64.rpm

echo "* Enable system module ..."
sudo metricbeat modules enable system
