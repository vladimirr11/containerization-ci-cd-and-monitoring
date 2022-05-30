#!/bin/bash

echo "* Download metricbeat ..."
wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.1.0-amd64.deb

echo "* Install metricbeat ..."
sudo dpkg -i metricbeat-8.1.0-amd64.deb

echo "* Enable system module ..."
sudo metricbeat modules enable system
