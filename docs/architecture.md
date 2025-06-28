# 🧠 Architecture: Home Automation DevOps

This document outlines the architecture and DevOps practices applied in this modular smart home project using **Home Assistant**, **Proxmox**, **LXC**, and **Docker**.

---

## 🏗️ System Overview

### Platform:
- **Proxmox VE**: Host hypervisor for LXC containers
- **LXC Container**: Lightweight, unprivileged Debian 12 container
- **Docker**: Container runtime for Home Assistant and other services
- **Home Assistant**: Main automation engine (running in Docker)

### Filesystem Mapping:
- Host volume: `/opt/homeassistant/config`
- Docker container: `/config`

### Network:
- LXC container gets IP via **DHCP**
- Home Assistant runs in `--network=host` mode (accessed via host IP)

---

## 📦 Components

| Component       | Technology         | Purpose                                 |
|----------------|--------------------|-----------------------------------------|
| Container Host | Proxmox VE         | Virtualization of LXC containers        |
| LXC Guest      | Debian 12          | Lightweight OS for Docker environment   |
| Home Assistant | Docker Container   | Smart home control and integrations     |
| File Share     | Samba (SMB)        | Expose `/config` to network editors     |

---

## ⚙️ DevOps Principles Applied

### 1. Infrastructure as Code (IaC)
- Provisioning of LXC container done via `pct` in a repeatable shell script
- Modular, version-controlled under `infrastructure/`

### 2. Configuration Management
- Home Assistant config is stored persistently under `/opt/homeassistant/config`
- Exposed via **SMB** with controlled ACL permissions for safe multi-user access

### 3. Containerization
- Home Assistant and all future modules (MQTT, Frigate, AI) are Dockerized
- Future-proofed for scale-out or migration

### 4. CI/CD Pipelines
- GitHub Actions lint all YAML files
- Deployment script is test-run inside simulated CI to verify shell logic

---

## 🔌 Modular Design

- Each integration (e.g., MQTT, Frigate, AI) lives in `modules/<name>/`
- Each module includes:
  - Setup script or Docker Compose
  - Integration guide
  - Example HA config snippet

---

## 🔐 Security Considerations

- Samba shares use a non-login system user with ACL
- No root exposure; LXC is unprivileged
- Docker runs with minimum permissions; no privileged containers

---

## 📈 Future Enhancements

| Area               | Plan                                               |
|--------------------|----------------------------------------------------|
| Monitoring         | Add Grafana + Prometheus in Docker                 |
| Secrets Management | GitHub Actions secrets or Vault integration        |
| IaC Evolution      | Convert shell scripts to Ansible or Terraform      |
| GitOps             | Auto-deploy on push to main via Proxmox API        |

---

## 🧪 Testing

| Component         | Test Strategy                                       |
|------------------|-----------------------------------------------------|
| YAML Configs      | Linted via GitHub Actions on every push             |
| Shell Scripts     | Simulated run inside GitHub CI                      |
| Container Runtime | Manually verified on Proxmox host                   |

---

## 📎 Related Files

- `lxc-setup/install_ha_docker.sh` – Container bootstrap script
- `infrastructure/proxmox/create_lxc_ha_base.sh` – LXC provisioning
- `.github/workflows/yaml-lint.yml` – CI pipeline for YAML linting

