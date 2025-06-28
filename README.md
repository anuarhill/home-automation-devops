
![CI](https://github.com/anuarhill/home-automation-devops/actions/workflows/yaml-lint.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)


# 🏡 Home Automation DevOps

This project showcases a modular, containerized home automation platform built on **Proxmox**, **LXC**, and **Docker**, with **Home Assistant** as the core. It demonstrates practical **DevOps principles** such as **Infrastructure as Code (IaC)**, **automation**, and **CI/CD pipelines** using **GitHub Actions**.

> ⚙️ Designed as a portfolio-ready project to illustrate real-world DevOps workflows in a smart home context.

---

## 📦 Project Overview

- 🧱 **Infrastructure**: Lightweight LXC containers on Proxmox, provisioned via shell scripts (IaC)
- 🐳 **Containers**: Home Assistant (base), with modular support for MQTT, Frigate NVR, AI face recognition
- 📁 **Config Management**: Config folder mapped with proper ACL and exposed via SMB share for remote editing
- 🚀 **CI/CD**: GitHub Actions to lint YAML configurations and simulate deployment pipelines
- 🔌 **Modularity**: Easily add services as standalone modules in `/modules/`

---

## 🗂️ Repository Structure

```
home-automation-devops/
├── lxc-setup/                        # Setup scripts for Home Assistant in LXC
├── infrastructure/                  # Infrastructure as Code (Proxmox LXC provisioning)
│   └── proxmox/
│       ├── create_lxc_ha_base.sh    # Creates HA LXC container
│       ├── create_mqtt_lxc.sh       # Creates MQTT LXC container
│       └── README.md                # Instructions for provisioning with pct
├── modules/                         # Optional integrations
│   └── mqtt/
│       ├── install_mqtt_docker.sh   # Installs Mosquitto via Docker + Samba setup
│       └── README.md                # Setup documentation for MQTT container
├── docs/                            # Architecture and design documentation
├── .github/workflows/               # GitHub Actions workflows (CI/CD)
└── README.md                        # Project overview (you are here)

```

## 📁 Folder Breakdown

- `lxc-setup/` – Setup scripts for bootstrapping Home Assistant in an LXC container.
- `infrastructure/proxmox/` – Scripts to provision unprivileged Debian LXC containers via `pct` (for Home Assistant and MQTT).
- `modules/mqtt/` – Installs Mosquitto MQTT broker in Docker, with ACL-secured Samba config sharing.
- `docs/` – System design, architecture diagrams, integration notes.
- `.github/workflows/` – GitHub Actions for CI/CD automation (e.g., YAML lint).
- `README.md` – High-level overview and instructions.


---

## 🚀 Getting Started

### 1. Provision the LXC container (Proxmox Host)
```bash
bash infrastructure/proxmox/create_lxc_ha_base.sh
```

### 2. Enter the LXC and install Home Assistant
```bash
bash lxc-setup/install_ha_docker.sh
```

### 3. Access Home Assistant
- URL: `http://<container-ip>:8123`
- Config folder: exposed via SMB at `\\<container-ip>\hassconfig`
- Username/password: `smbuser / smbuser`

---

## 🧠 DevOps Concepts Demonstrated

| Concept           | Implementation                          |
|------------------|------------------------------------------|
| IaC              | Shell scripts to provision LXC + Docker  |
| Containerization | Dockerized services with mounted config  |
| Config Mgmt      | ACL + SMB for remote YAML editing        |
| CI/CD            | GitHub Actions for lint + deploy         |
| Modularity       | `/modules/` folder for service extensions|

---

## 🔧 Coming Soon

- [x] `modules/mqtt` – Mosquitto container + HA integration
- [ ] `modules/frigate` – Local NVR with camera stream detection
- [ ] `modules/ai-facial-recognition` – Face detection & automation
- [ ] Monitoring & alerting via Grafana + Prometheus


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
>>>>>>> 30058a1 (First setup)
# home-automation-devops
Modular home automation setup using Home Assistant, Docker, and LXC on Proxmox with DevOps principles
