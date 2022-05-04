#!/bin/bash

echo "* Join swarm ..."
docker swarm join --token $(cat /swarm/worker_token.txt) --advertise-addr 192.168.99.103 192.168.99.101:2377
