#!/bin/bash

mkdir prometheus && cd prometheus

echo "* Copy locally prometheus.yml ..."
cp /vagrant/prometheus.yml .

echo "* Copy locally daemon.json to configure the Docker daemon as a Prometheus target ..."
cp /vagrant/daemon.json /etc/docker/

echo "* Restart the docker service ..."
sudo systemctl restart docker

echo "* Run prometheus container on port 9090 ..."
docker container run -d --name prometheus -p 9090:9090 -v /home/vagrant/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus

echo "* Run goprom app instances ..."
docker container run -d --name goapp1 -p 8081:8080 shekeriev/goprom
docker container run -d --name goapp2 -p 8082:8080 shekeriev/goprom

echo "* Run grafana container ..."
docker volume create grafana
docker run -d -p 3000:3000 --name grafana --rm -v grafana:/var/lib/grafana grafana/grafana-oss
