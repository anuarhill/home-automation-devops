# 🛰️ MQTT Container Setup (Docker on LXC)

This folder contains a script to install and run an MQTT broker (Mosquitto) in a Docker container within an **unprivileged LXC** on Proxmox VE.

---

## 🧾 Script: `install_mqtt_docker.sh`

This script performs the following tasks:

### 🐳 Docker + Samba Setup

- Installs Docker, Samba, and ACL
- Enables Docker service
- Prepares Mosquitto folder structure

### ⚙️ Mosquitto Configuration

- Creates a default `mosquitto.conf` file with:
  - Persistent storage
  - Password authentication
- Adds a default user `mqttuser` with password `mqttpassword` using `mosquitto_passwd`

### 🛠️ Docker Container Launch

- Runs Mosquitto container with:
  - Host port `1883` exposed
  - Mounted volumes for `/config`, `/data`, `/log`
  - Root user to avoid permission warnings

### 🔗 SMB Share (Optional)

- Creates Samba user `smbuser` with the same password
- Shares the `/opt/mosquitto/config` folder via SMB
- Ensures ACL permissions are set for the share

---

## ▶️ How to Use

SSH into your MQTT LXC container and run:

```bash
bash install_mqtt_docker.sh
```

---

## 🔐 Access Details

- MQTT Username: `mqttuser`
- MQTT Password: `mqttpassword`
- Config Folder Share: `\\<container-ip>\mqttconfig` (accessible from Windows/Mac)

---

## 🤝 Integration: Home Assistant + MQTT

Once the MQTT broker is running:

1. **Get the container's IP address**:
   ```bash
   ip a
   ```
   (Look under `eth0`, e.g., `192.168.1.123`)

2. **Enable MQTT integration in Home Assistant**:
   - Go to **Settings > Devices & Services > Add Integration**
   - Select **MQTT**
   - Enter the following:
     - **Host:** `192.168.1.123`
     - **Port:** `1883`
     - **Username:** `mqttuser`
     - **Password:** `mqttpassword`

3. **(Optional)**: Add manually in `configuration.yaml`:
   ```yaml
   mqtt:
     broker: 192.168.1.123
     port: 1883
     username: mqttuser
     password: mqttpassword
   ```

4. **Restart Home Assistant** and confirm connectivity.

---



## 🧠 DevOps Principle: Containerized Service

This setup follows DevOps principles:

- Reproducible setup via script
- Containerized service deployment
- Configuration exposed via SMB for easy management
