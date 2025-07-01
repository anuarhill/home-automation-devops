# 📈 Grafana Dashboard Setup (DevOps Edition)

This guide walks you through creating a robust Grafana dashboard to visualize metrics from Prometheus. It emphasizes reusability, modularity, and automation—DevOps style.

---

## 🧰 Prerequisites

- Grafana and Prometheus installed (see `README_monitoring.md`)
- Prometheus data source added in Grafana
- Node Exporter or Home Assistant metrics available
- Access to Grafana UI (`http://<container-ip>:3000`)

---

## 🧪 Step-by-Step: Create a Dashboard

### 1. Log in to Grafana
- URL: `http://<container-ip>:3000`
- Default credentials: `admin / admin`

### 2. Add Prometheus as a Data Source
- Go to **Gear Icon → Data Sources**
- Click **Add data source**
- Choose **Prometheus**
- Set URL: `http://localhost:9090`
- Click **Save & Test**

### 3. Create a New Dashboard
- Click **+ → Dashboard → Add new panel**
- Select **Prometheus** as the data source
- Enter a query (e.g., `node_cpu_seconds_total{mode="idle"}`)
- Choose a visualization (e.g., Time series, Gauge, Stat)
- Click **Apply**

### 4. Add More Panels
- Use queries like:
  - `node_memory_MemAvailable_bytes`
  - `node_load1`
  - `node_network_receive_bytes_total`
- Customize each panel with titles, units, thresholds

### 5. Save the Dashboard
- Click **Save icon**
- Name your dashboard (e.g., `System Overview`)
- Optionally, add tags like `devops`, `monitoring`

---

## 🧬 Import Prebuilt Dashboards

Grafana has a rich library of community dashboards:

1. Go to **+ → Import**
2. Paste a dashboard ID (e.g. 1860) from [Grafana Dashboards](https://grafana.com/grafana/dashboards/)
3. Select Prometheus as the data source
4. Click **Import**

---

## 🧑‍💻 Dashboard as Code (Optional)

For version control and automation:

- Export dashboard JSON via **Dashboard Settings → JSON Model**
- Store in Git
- Use provisioning or tools like `grafonnet` or Terraform to deploy

---

## 📺 Recommended Tutorials

1. [Creating Grafana Dashboards for Prometheus](https://www.youtube.com/watch?v=EGgtJUjky8w)
2. [Grafana 10.1 Visualizations and Layout Tips](https://www.youtube.com/watch?v=051wmmDNJnc)
3. [How To Setup A Grafana Dashboard Step By Step](https://www.youtube.com/watch?v=4qpI4T6_bUw)
4. [Grafana Dashboards Basics](https://www.youtube.com/watch?v=aiLkHtmrSAU)
5. [Dashboard List Visualization Deep Dive](https://www.youtube.com/watch?v=MserjWGWsh8)

---

## 🧠 Pro Tips

- Use **templating variables** for dynamic dashboards
- Set **alert rules** for critical metrics
- Use **library panels** to reuse visualizations across dashboards
- Enable **auto-refresh** (e.g., every 5s) for real-time monitoring
