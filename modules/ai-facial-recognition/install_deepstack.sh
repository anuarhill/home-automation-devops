
---

## Here is the shell script content (`install_deepstack.sh`):

```bash
#!/bin/bash

set -e

echo "🔄 Updating package lists..."
apt update

echo "📦 Installing prerequisites (curl, apt-transport-https, ca-certificates, gnupg, lsb-release)..."
apt install -y curl apt-transport-https ca-certificates gnupg lsb-release software-properties-common

echo "🐳 Installing Docker..."

if ! command -v docker &> /dev/null; then
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

  apt update
  apt install -y docker-ce docker-ce-cli containerd.io
else
  echo "Docker is already installed"
fi

echo "🛠 Starting Docker service..."
systemctl enable docker
systemctl start docker

echo "🐋 Pulling Deepstack latest image..."
docker pull deepquestai/deepstack:latest

echo "🚀 Running Deepstack container with face recognition enabled..."

docker run -d \
  --name deepstack \
  -e VISION-FACE=True \
  -p 5000:5000 \
  --restart unless-stopped \
  deepquestai/deepstack:latest

echo "✅ Deepstack setup completed."
echo "Access Deepstack API at http://<LXC_IP>:5000"

