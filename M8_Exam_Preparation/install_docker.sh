#!/bin/bash

echo "* Add the Docker repository ..."
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "* Install the packages (Java, git, Docker) ..."
dnf install -y java-11-openjdk git docker-ce docker-ce-cli containerd.io

echo "* Start the Docker service ..."
systemctl enable --now docker

echo "* Adjust the group membership ..."
usermod -aG docker vagrant

echo "* Install Docker Compose ..."
mkdir -p /home/vagrant/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o /home/vagrant/.docker/cli-plugins/docker-compose
chmod +x /home/vagrant/.docker/cli-plugins/docker-compose

chown -R vagrant:vagrant /home/vagrant/.docker

echo "* Copy the Compose plugin for root user"
mkdir -p /root/.docker/cli-plugins
cp /home/vagrant/.docker/cli-plugins/docker-compose /root/.docker/cli-plugins/

echo "* Adjust firewall ports ..."
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload
