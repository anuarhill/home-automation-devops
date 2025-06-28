#!/bin/bash
set -e

# ---------------------------------------------
# Update and install Docker + Samba
# ---------------------------------------------
apt update && apt upgrade -y
apt install -y docker.io samba samba-common-bin acl

systemctl enable docker
systemctl start docker

# ---------------------------------------------
# Prepare folder structure
# ---------------------------------------------
mkdir -p /opt/mosquitto/{config,data,log}
touch /opt/mosquitto/config/passwd
chmod 600 /opt/mosquitto/config/passwd
chown root:root /opt/mosquitto/config/passwd

# ---------------------------------------------
# Create Mosquitto config file
# ---------------------------------------------
cat <<EOF > /opt/mosquitto/config/mosquitto.conf
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log

listener 1883
allow_anonymous false
password_file /mosquitto/config/passwd
EOF

# ---------------------------------------------
# Create MQTT user/password using Docker
# ---------------------------------------------
docker run --rm \
  -v /opt/mosquitto/config:/mosquitto/config \
  eclipse-mosquitto \
  mosquitto_passwd -b /mosquitto/config/passwd mqttuser mqttpassword

# ---------------------------------------------
# Fix ownership inside the container volume mount
# ---------------------------------------------
docker run --rm \
  -v /opt/mosquitto/config:/mosquitto/config \
  --entrypoint chown \
  eclipse-mosquitto root:root /mosquitto/config/passwd

# ---------------------------------------------
# Run Mosquitto container as root user to avoid warnings
# ---------------------------------------------
docker run -d --name mosquitto --restart=unless-stopped \
  -p 1883:1883 \
  -v /opt/mosquitto/config:/mosquitto/config \
  -v /opt/mosquitto/data:/mosquitto/data \
  -v /opt/mosquitto/log:/mosquitto/log \
  --user root \
  eclipse-mosquitto

# ---------------------------------------------
# Optional: Setup Samba access to config folder
# ---------------------------------------------
useradd -M -s /usr/sbin/nologin smbuser || true
(echo smbuser; sleep 1; echo smbuser) | smbpasswd -a -s smbuser

chown -R smbuser:smbuser /opt/mosquitto
chmod -R 770 /opt/mosquitto
setfacl -R -m u:smbuser:rwx /opt/mosquitto
setfacl -dR -m u:smbuser:rwx /opt/mosquitto

cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

cat <<EOT >> /etc/samba/smb.conf

[mqttconfig]
  path = /opt/mosquitto/config
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

systemctl restart smbd
systemctl enable smbd

# ---------------------------------------------
# Final Message
# ---------------------------------------------
echo "✅ MQTT Docker container setup complete."
echo "🔐 Username: mqttuser"
echo "🔑 Password: mqttpassword"
echo "📁 Config shared at: \\\\<container-ip>\\mqttconfig"
