# 🧱 Infrastructure: Proxmox LXC Provisioning

This folder contains Infrastructure as Code (IaC) examples for provisioning an LXC container in **Proxmox VE** to run Home Assistant in Docker.

---

## 🧾 Script: `create_lxc_ha_base.sh`

This script uses `pct` to:

- Create an unprivileged LXC container (Debian 12)
- Set 8 GB RAM, 2 vCPUs
- Enable nesting for Docker
- Start the container immediately

### 📦 LXC Template Required

Make sure you have the following template on your Proxmox host:

```bash
/var/lib/vz/template/cache/debian-12-standard_12.7-1_amd64.tar.zst
```

You can download it from the Proxmox Web UI > Node > Templates.

---

## ▶️ How to Use

SSH into your Proxmox node and run:

```bash
bash infrastructure/proxmox/create_lxc_ha_base.sh
```

This will provision a container with ID `305` and start it with DHCP networking.

---

## 🧠 DevOps Principle: IaC

While this is a shell-based implementation, it reflects the **declarative intent** of IaC:

- Repeatable
- Documented
- Version-controlled
- Evolvable to Terraform or Ansible later
