# 🧱 Proxmox LXC Provisioning (Infrastructure as Code)

This folder contains shell scripts to provision unprivileged LXC containers on a **Proxmox VE** host for the **Home Automation DevOps** project. Each container is configured for a specific service (e.g., Home Assistant, MQTT, Frigate, Monitoring stack) and follows IaC principles.

---

## 🗂️ Scripts Overview

| Script                         | Purpose                                   |
|-------------------------------|-------------------------------------------|
| create_lxc_ha_base.sh         | Provision Home Assistant container        |
| create_lxc_mqtt.sh            | Provision Mosquitto MQTT container        |
| create_lxc_frigate.sh         | Provision Frigate NVR container           |
| create_lxc_monitoring.sh    | Provision Prometheus + Grafana container  |

---

## ✅ Requirements

- Proxmox VE (tested on 7.x / 8.x)
- Debian 12 LXC templates available
- Run scripts as root or user with `pct` privileges

---

## ⚙️ Usage

```bash
# From the Proxmox host:
bash create_lxc_ha_base.sh
bash create_mqtt_lxc.sh
bash create_frigate_lxc.sh
bash create_monitoring_stack.sh
```

---

## 🧠 Notes

- All containers are **unprivileged** for better security.
- Network is DHCP by default — reserve IPs via DHCP lease or set static IPs manually.
- LXC storage is configured to support Docker workloads (nesting + key mounts).