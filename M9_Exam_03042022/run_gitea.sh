#!/bin/bash

echo "* Run gitea container ..."
mkdir gitea && cd gitea && cp /vagrant/docker-compose.yml .
docker compose up -d
