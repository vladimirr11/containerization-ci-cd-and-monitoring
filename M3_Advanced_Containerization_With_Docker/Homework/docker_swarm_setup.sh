#!/bin/bash

echo "* Init docker swarm ..."
docker swarm init --advertise-addr 192.168.99.101

echo "* Expose worker token ..."
docker swarm join-token -q worker > /swarm/worker_token.txt
