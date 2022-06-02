#!/bin/bash

echo "* Add Jenkins repository ..."
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

echo "* Import Jenkins repository key ..."
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

echo "* Update repositories and install components ..."
yum upgrade
yum install -y java-11-openjdk
yum install -y jenkins git nano
systemctl daemon-reload

echo "* Change default Jenkins shell ..."
usermod -s /bin/bash jenkins

echo "* Enable and start Jenkins ..."
systemctl enable jenkins
systemctl start jenkins

echo "* Adjust firewall ports ..."
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload
