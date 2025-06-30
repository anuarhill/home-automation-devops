#!/bin/bash
# install_monitoring_stack.sh
# Installs Prometheus + Grafana Docker stack on a Debian-based LXC container

set -e

echo "🔄 Updating packages..."
apt update && apt upgrade -y

echo "🐳 Installing Docker and Docker Compose..."
apt install -y docker.io docker-compose

echo "📁 Creating monitoring directory structure..."
mkdir -p /opt/monitoring/prometheus /opt/monitoring/grafana

echo "📝 Writing Prometheus config..."
cat <<EOF > /opt/monitoring/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: "node_exporter"
    static_configs:
      - targets: ["node_exporter:9100"]
EOF

echo "🧾 Creating Docker Compose file..."
cat <<EOF > /opt/monitoring/docker-compose.yml
version: '3'

services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
    restart: unless-stopped

  grafana:
    image: grafana/grafana
    volumes:
      - grafana-storage:/var/lib/grafana
    ports:
      - "3000:3000"
    restart: unless-stopped

  node_exporter:
    image: prom/node-exporter
    ports:
      - "9100:9100"
    restart: unless-stopped

volumes:
  grafana-storage:
EOF

echo "🚀 Starting Prometheus + Grafana stack..."
cd /opt/monitoring
docker-compose up -d

echo "✅ Monitoring stack installed. Access Grafana at http://<LXC-IP>:3000 (login: admin / admin)"
echo "📊 Prometheus is available at http://<LXC-IP>:9090"