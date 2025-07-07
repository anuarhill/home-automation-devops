#!/bin/bash

set -e

echo "🔄 Updating package lists..."
apt update

echo "📦 Installing Docker from default Debian repositories..."
apt install -y docker.io

echo "🚀 Enabling and starting Docker..."
systemctl enable docker
systemctl start docker

echo "📂 Creating folders for Double Take storage..."
mkdir -p /root/double-take/.double-take
cd /root/double-take


echo "📦 Running Double Take container..."
docker run -d \
  --name double-take \
  -v /root/double-take/.double-take:/.storage \
  -p 3000:3000 \
  --restart unless-stopped \
  skrashevich/double-take:latest

echo "✅ Double Take installation and launch complete."
echo "👉 Access the UI at: http://<this-host-ip>:3000"
