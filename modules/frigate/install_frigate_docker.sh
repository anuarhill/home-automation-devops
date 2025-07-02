#!/bin/bash
# install_frigate_docker.sh
# Installs Frigate NVR in Docker for Home Assistant integration

set -e

echo "🔧 Installing dependencies..."
apt update && apt install -y     docker.io     docker-compose     ffmpeg     curl

echo "📁 Creating Frigate config directory..."
mkdir -p /opt/frigate/config

echo "📝 Creating default docker-compose.yml..."
cat <<EOF > /opt/frigate/docker-compose.yml
version: '3.9'
services:
  frigate:
    container_name: frigate
    privileged: true
    restart: unless-stopped
    image: ghcr.io/blakeblackshear/frigate:stable
    shm_size: "512mb"
#    devices:
#      - /dev/bus/usb:/dev/bus/usb
#      - /dev/dri:/dev/dri
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /opt/frigate/config:/config
      - /media/frigate:/media/frigate
    ports:
      - "5000:5000"
      - "1935:1935"
      - "8554:8554"
      - "8555:8555/tcp"
      - "8555:8555/udp"
    environment:
      - FRIGATE_RTSP_PASSWORD=changeme
EOF

echo "🚀 Starting Frigate container..."
cd /opt/frigate && docker-compose up -d

echo "✅ Frigate installed and running on port 5000"
