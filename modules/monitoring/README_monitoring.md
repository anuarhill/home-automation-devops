# 📊 Monitoring Stack: Prometheus + Grafana

This module sets up a monitoring and observability stack for Home Assistant and the host system using **Prometheus** and **Grafana**, running in Docker inside a dedicated LXC container.

---

## 🚀 Features

- Prometheus scrapes metrics from:
  - Home Assistant (via Prometheus integration)
  - Node Exporter on host or LXC
- Grafana provides dashboards and alerting
- Easy to extend with custom scrape targets

---

## 🛠️ Installation

### 1. Enter the monitoring LXC
```bash
pct exec <CTID> -- bash
```

### 2. Run the setup script
```bash
bash modules/monitoring/install_monitoring_stack.sh
```

---

## 🌐 Access

- **Grafana**: `http://<container-ip>:3000`  
  Default login: `admin / admin`
- **Prometheus**: `http://<container-ip>:9090`

---

## ⚙️ Notes

- Update `prometheus.yml` with correct target IPs before running.
- You can add Alertmanager or exporters as needed.
- Node Exporter must be installed and accessible from Prometheus.

---

## 📎 References

- [Grafana Documentation](https://grafana.com/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [HA Prometheus Integration](https://www.home-assistant.io/integrations/prometheus/)