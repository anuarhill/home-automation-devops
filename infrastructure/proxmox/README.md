# 🧱 Infrastructure: Proxmox LXC Provisioning

This folder contains Infrastructure as Code (IaC) examples for provisioning LXC containers in **Proxmox VE** to run Home Assistant and MQTT (Mosquitto) in Docker.

---

## 🧾 Script: `create_lxc_ha_base.sh`

This script uses `pct` to:

- Create an unprivileged LXC container (Debian 12)
- Set 8 GB RAM, 2 vCPUs
- Enable nesting for Docker
- Start the container immediately with DHCP networking

### 📦 LXC Template Required

Make sure you have the following template on your Proxmox host:

```bash
/var/lib/vz/template/cache/debian-12-standard_12.7-1_amd64.tar.zst
```

You can download it from the Proxmox Web UI > Node > Templates.

---

## 🧾 Script: `create_lxc_mqtt.sh`

This script uses `pct` to:

- Create an unprivileged LXC container (Debian 12)
- Set 2 GB RAM, 1 vCPU
- Enable nesting for Docker
- Start the container immediately with DHCP networking

```bash
#!/bin/bash
# Script to create MQTT LXC container in Proxmox

pct create 306 /var/lib/vz/template/cache/debian-12-standard_12.7-1_amd64.tar.zst \
  --hostname mqtt-docker \
  --cores 1 \
  --memory 2048 \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp \
  --rootfs local-lvm:4 \
  --features nesting=1 \
  --unprivileged 1 \
  --start 1

echo "✅ MQTT LXC container created and started."
```

---

## ▶️ How to Use

SSH into your Proxmox node and run the desired script:

```bash
bash infrastructure/proxmox/create_lxc_ha_base.sh
```

or

```bash
bash infrastructure/proxmox/create_lxc_mqtt.sh
```

Each will provision its respective container with DHCP networking.

---

## 🧠 DevOps Principle: IaC

While these are shell-based implementations, they reflect the **declarative intent** of Infrastructure as Code:

- Repeatable
- Documented
- Version-controlled
- Evolvable to Terraform or Ansible later
