#!/bin/bash
set -e  # Exit immediately if a command fails

# ---------------------------------------------
# Update system and install required packages
# ---------------------------------------------
apt update && apt upgrade -y
apt install -y software-properties-common apt-transport-https ca-certificates curl samba samba-common-bin acl

# ---------------------------------------------
# Add Docker GPG key and repository
# ---------------------------------------------
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
tee /etc/apt/sources.list.d/docker.list

# ---------------------------------------------
# Install Docker components
# ---------------------------------------------
apt update
apt install -y docker-ce docker-ce-cli containerd.io

# ---------------------------------------------
# Enable and start Docker service
# ---------------------------------------------
systemctl enable docker
systemctl start docker

# ---------------------------------------------
# Create directory structure for Home Assistant config
# Home Assistant config will reside in: /opt/homeassistant/config
# This folder will be mapped to /config inside the container
# ---------------------------------------------
mkdir -p /opt/homeassistant/config
chown 1000:1000 /opt/homeassistant/config

# ---------------------------------------------
# Run Home Assistant container
# - Mount /opt/homeassistant/config as /config inside container
# ---------------------------------------------
docker run -d --name homeassistant --restart=unless-stopped \
  -v /opt/homeassistant/config:/config \
  --network=host \
  ghcr.io/home-assistant/home-assistant:stable

# ---------------------------------------------
# Create a Samba system user for network share access (no login shell)
# ---------------------------------------------
if ! id -u smbuser >/dev/null 2>&1; then
  useradd -M -s /usr/sbin/nologin smbuser
fi

# Set Samba password for smbuser
(echo smbuser; sleep 1; echo smbuser) | smbpasswd -a -s smbuser

# ---------------------------------------------
# Set ownership and permissions for SMB access
# Includes ACLs to ensure consistent read/write access
# ---------------------------------------------
chown -R smbuser:smbuser /opt/homeassistant
chmod -R 0770 /opt/homeassistant
setfacl -R -m u:smbuser:rwx /opt/homeassistant
setfacl -dR -m u:smbuser:rwx /opt/homeassistant

# ---------------------------------------------
# Backup existing Samba configuration
# ---------------------------------------------
cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

# ---------------------------------------------
# Configure the Samba share for the HA config folder
# Only applies if the [hassconfig] block doesn't already exist
# ---------------------------------------------
if ! grep -q '\[hassconfig\]' /etc/samba/smb.conf; then
  cat <<EOT >> /etc/samba/smb.conf

[hassconfig]
  path = /opt/homeassistant/config
  browseable = yes
  read only = no
  valid users = smbuser
  force user = smbuser
  create mask = 0660
  directory mask = 0770
  vfs objects = acl_xattr
  map acl inherit = yes
  store dos attributes = yes
EOT
fi

# ---------------------------------------------
# Restart Samba and enable it on boot
# ---------------------------------------------
systemctl restart smbd
systemctl enable smbd

# ---------------------------------------------
# Final info message
# ---------------------------------------------
echo "✅ Setup complete."
echo "📁 Home Assistant config is in: /opt/homeassistant/config"
echo "🌐 SMB share available at: \\\\<container-ip>\\hassconfig"
echo "👤 Samba user: smbuser"
echo "🔑 Samba password: smbuser"

