# 🛠️ LXC Setup for Home Assistant

This directory contains the installation script to set up **Home Assistant (Container)** inside an **unprivileged LXC** on **Proxmox VE**, using **Docker**. It also includes configuration of an **SMB share** for accessing `configuration.yaml` remotely.

---

## 📋 What This Script Does

- Installs Docker and required packages in the container
- Pulls the latest Home Assistant container image
- Mounts `/opt/homeassistant/config` as the config directory
- Creates an SMB share with ACL permissions to allow network editing
- Sets up a Samba user (`smbuser`) with password `smbuser`

---

## 📁 Folder Structure Inside LXC

```
/opt/homeassistant/
└── config/       # This folder is mapped to /config in Docker
```

---

## ⚙️ How to Use

1. **SSH into the LXC container** created via Proxmox.
2. Copy the script into the container.
3. Make it executable:
   ```bash
   chmod +x install_ha_docker.sh
   ```
4. Run it:
   ```bash
   ./install_ha_docker.sh
   ```

---

## 🔒 Network Share Access

- SMB share path: `\\<container-ip>\hassconfig`
- Username: `smbuser`
- Password: `smbuser`
- Works with macOS Finder (`⌘K` > `smb://<container-ip>/hassconfig`)

---

## ✅ Requirements

- Debian 12 LXC (unprivileged)
- Proxmox VE host with Docker-compatible kernel
