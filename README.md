![CI](https://github.com/anuarhill/home-automation-devops/actions/workflows/yaml-lint.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# 🏡 Home Automation DevOps

This project showcases a modular, containerized home automation platform built on **Proxmox**, **LXC**, and **Docker**, with **Home Assistant** as the core. It demonstrates practical **DevOps principles** such as **Infrastructure as Code (IaC)**, **automation**, and **CI/CD pipelines** using **GitHub Actions**.

> ⚙️ Designed as a portfolio-ready project to illustrate real-world DevOps workflows in a smart home context.

---

## 📦 Project Overview

- 🧱 **Infrastructure**: Lightweight LXC containers on Proxmox, provisioned via shell scripts (IaC)
- 🐳 **Containers**: Home Assistant (base), MQTT, Frigate NVR, AI face recognition, Prometheus + Grafana
- 📁 **Config Management**: Config folder mapped with proper ACL and exposed via SMB share for remote editing
- 🚀 **CI/CD**: GitHub Actions to lint YAML configurations and simulate deployment pipelines
- 📊 **Monitoring**: Prometheus + Grafana integrated for observability, with alerting options
- 🔌 **Modularity**: Easily add services as standalone modules in `/modules/`

---

## 🗂️ Repository Structure

```
home-automation-devops/
├── lxc-setup/
│   ├── install_ha_docker.sh
│   └── README.md
├── infrastructure/
│   └── proxmox/
│       ├── create_lxc_ha_base.sh
│       ├── create_lxc_mqtt.sh
│       ├── create_lxc_frigate.sh
│       ├── create_lxc_monitoring.sh
│       └── README_proxmox.md
├── modules/
│   ├── mqtt/
│   │   ├── install_mqtt_docker.sh
│   │   └── README.md
│   ├── frigate/
│   │   ├── install_frigate_docker.sh
│   │   └── README.md
│   ├── ai-facial-recognition/
│   │   ├── install_faceai_docker.sh
│   │   └── README.md
│   └── monitoring/
│       ├── install_monitoring_stack.sh
│       └── README.md
├── docs/
│   ├── architecture.md
│   └── integrations.md
├── .github/workflows/
│   └── yaml-lint.yml
└── README.md
```

## 📁 Folder Breakdown

- `lxc-setup/` – Setup scripts for bootstrapping Home Assistant in an LXC container.
- `infrastructure/proxmox/` – Scripts to provision unprivileged Debian LXC containers via `pct`.
- `modules/mqtt/` – Installs Mosquitto MQTT broker in Docker.
- `modules/frigate/` – NVR using Frigate for object and motion detection.
- `modules/ai-facial-recognition/` – AI-based face recognition pipeline for automation triggers.
- `modules/monitoring/` – Prometheus + Grafana setup for metrics + dashboards.
- `docs/` – System design, architecture diagrams, and integration notes.
- `.github/workflows/` – GitHub Actions for CI/CD automation.
- `README.md` – Project overview.

---

## 🚀 Getting Started

### 1. Provision LXC containers on Proxmox
```bash
bash infrastructure/proxmox/create_lxc_ha_base.sh
bash infrastructure/proxmox/create_mqtt_lxc.sh
bash infrastructure/proxmox/create_frigate_lxc.sh
bash infrastructure/proxmox/create_monitoring_stack.sh
```

### 2. Install service stacks inside each LXC
```bash
# Inside each LXC
bash lxc-setup/install_ha_docker.sh
bash modules/mqtt/install_mqtt_docker.sh
bash modules/frigate/install_frigate_docker.sh
bash modules/monitoring/install_monitoring_stack.sh
bash modules/ai-facial-recognition/install_faceai_docker.sh
```

### 3. Access Home Assistant
- URL: `http://<container-ip>:8123`
- Config folder: `\<container-ip>\hassconfig`
- SMB Login: `smbuser / smbuser`

### 4. Access Grafana Dashboard
- URL: `http://<monitoring-ip>:3000`
- Login: `admin / admin` (change after login)

---

## 🧠 DevOps Concepts Demonstrated

| Concept           | Implementation                                   |
|------------------|---------------------------------------------------|
| IaC              | LXC provisioning scripts (Proxmox)                |
| Containerization | Dockerized HA + MQTT + Frigate + Monitoring stack |
| Config Mgmt      | ACL-secured Samba shares for YAML editing         |
| CI/CD            | YAML linting with GitHub Actions                  |
| Observability    | Prometheus Node Exporter + Grafana Dashboards     |
| Modularity       | `/modules/` for plug-and-play integrations        |

---

## ✅ Completed Modules

- [x] `modules/mqtt` – Mosquitto container + HA integration
- [ ] `modules/frigate` – Local NVR with camera stream detection
- [ ] `modules/ai-facial-recognition` – Face detection & automation
- [x] `modules/monitoring` – Grafana + Prometheus + alerting

---

## 🪪 License

MIT License © [Anuar Hill](https://github.com/anuarhill)

---

## 💡 Inspiration

This project is part of a larger effort to demonstrate real-world DevOps skills through home automation. It reflects experience in:
- Shell scripting for systems automation
- Infrastructure design on Proxmox
- Container orchestration basics
- CI/CD mindset applied to YAML-based workflows
- Observability and monitoring integration