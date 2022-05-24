#!/bin/bash

echo "* Add hosts ..."
echo "192.168.99.100 jdocker.do1.lab docker" >> /etc/hosts

echo "* Add Docker repository ..."
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "* Install Docker ..."
dnf install -y docker-ce docker-ce-cli containerd.io

echo "* Enable and start Docker ..."
systemctl enable --now docker

echo "* Add vagrant user to docker group ..."
usermod -aG docker vagrant

echo "* Add Jenkins repository ..."
sudo wget https://pkg.jenkins.io/redhat/jenkins.repo -O /etc/yum.repos.d/jenkins.repo

echo "* Import Jenkins repository key ..."
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

echo "* Update repository information ..."
sudo dnf -y update

echo "* Install Jenkins ..."
sudo dnf install -y jenkins

echo "* Change default Jenkins shell ..."
sudo usermod -s /bin/bash jenkins

echo "* Install Java 11 ..."
sudo dnf install -y java-11-openjdk

echo "* Enable and start Jenkins ..."
sudo systemctl enable --now jenkins

echo "* Install Additional Packages ..."
dnf install -y jq tree git nano

echo "* Firewall - open port 8080 ..."
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload
