#!/bin/bash

echo "* Add Docker repository ..."
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "* Install Docker ..."
dnf install -y bash-completion docker-ce docker-ce-cli containerd.io

echo "* Adjust Docker configuration ..."
mkdir -p /etc/docker
echo '{ "hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"] }' | tee /etc/docker/daemon.json
mkdir -p /etc/systemd/system/docker.service.d/
echo [Service] | tee /etc/systemd/system/docker.service.d/docker.conf
echo ExecStart= | tee -a /etc/systemd/system/docker.service.d/docker.conf
echo ExecStart=/usr/bin/dockerd | tee -a /etc/systemd/system/docker.service.d/docker.conf

echo "* Start Docker service ..."
systemctl enable --now docker

echo "* Add vagrant user to docker group ..."
usermod -aG docker vagrant

echo "* Install Docker Compose as a plugin for the vagrant user ..."
mkdir -p /home/vagrant/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o /home/vagrant/.docker/cli-plugins/docker-compose
chmod +x /home/vagrant/.docker/cli-plugins/docker-compose

echo "* Adjust firewall rules ..."
firewall-cmd --add-port 8080/tcp --permanent
firewall-cmd --add-port 5000/tcp --permanent
firewall-cmd --add-port 5601/tcp --permanent
firewall-cmd --add-port 9200/tcp --permanent
firewall-cmd --add-port 9300/tcp --permanent
firewall-cmd --reload
