#/bin/bash

echo "* Download and extract prometheous ..."
wget https://github.com/prometheus/prometheus/releases/download/v2.33.5/prometheus-2.33.5.linux-amd64.tar.gz
tar xzvf prometheus-2.33.5.linux-amd64.tar.gz
mv prometheus-2.33.5.linux-amd64 prometheus

echo "* Download and extract grafana ..."
wget https://dl.grafana.com/enterprise/release/grafana-enterprise-8.4.5.linux-amd64.tar.gz
tar -zxvf grafana-enterprise-8.4.5.linux-amd64.tar.gz
mv grafana-8.4.5 grafana

echo "* Start grafana ..."
cd grafana/bin && ./grafana-server &> /tmp/grafana.log &

echo "* Start prometheus ..."
cd prometheus && mv prometheus.yml prometheus.yml.bak
cp /vagrant/prometheus.yml .
./prometheus --config.file prometheus.yml --web.enable-lifecycle &>> /tmp/prometheus.log &

echo "* Install nano ..."
dnf install -y nano

echo "* Adjust firewall ports ..."
firewall-cmd --add-port=9090/tcp --permanent
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload
