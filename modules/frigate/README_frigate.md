# 📹 Frigate Module

Frigate is an open-source NVR that uses real-time object detection with AI acceleration to power smart home video surveillance.

## 🚀 Installation

Run the installer inside the target LXC container:
```bash
bash modules/frigate/install_frigate_docker.sh
```

## 📁 Directory Structure

```
/opt/frigate/
├── config/              # Frigate configuration (YAML)
└── docker-compose.yml   # Docker Compose definition
```

## 🌐 Access

- Frigate UI: `http://<container-ip>:5000`
- RTMP Stream: `rtmp://<container-ip>/live/<camera_name>`
- RTSP Stream: `rtsp://<container-ip>:8554/<camera_name>`

## 🧠 Integration with Home Assistant

1. Add the Frigate integration from the HA UI.
2. Use the IP and port of this container (`5000`) as the Frigate URL.
3. Configure Frigate's `config.yml` to match camera settings and detection zones.

## ⚙️ Environment Variables

- `FRIGATE_RTSP_PASSWORD`: Used for secure camera streams (default: `changeme`).

## 🗑️ Uninstall

```bash
cd /opt/frigate
docker-compose down
rm -rf /opt/frigate
```
