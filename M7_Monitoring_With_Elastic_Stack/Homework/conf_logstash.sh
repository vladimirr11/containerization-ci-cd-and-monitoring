#!/bin/bash

echo "* Configure logstash to receive data from metricbeat and to forward the data to Elasticsearch ..."
cp /vagrant/beats.conf /etc/logstash/conf.d/
