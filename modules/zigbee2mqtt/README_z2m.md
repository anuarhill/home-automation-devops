
# 🧿 Zigbee2MQTT Integration Module

This module sets up **Zigbee2MQTT** in a Docker container, enabling integration of Zigbee devices into Home Assistant via MQTT. It supports both USB and **network-based Zigbee dongles** (e.g., SMLIGHT SLZB-06M), enabling flexible deployment on modern smart home infrastructures.

## 📦 Features

- Runs Zigbee2MQTT in a Docker container
- Supports **network-based Zigbee dongles** via TCP (e.g., SLZB-06M)
- Automatically connects to Mosquitto MQTT broker
- Mounts persistent data volume for configuration and state
- Supports automatic Zigbee device discovery in Home Assistant
- Easy access to Zigbee2MQTT Web UI for device pairing and control
- Integration-ready with Home Assistant via MQTT discovery

## 📁 Folder Contents

- `install_z2m_docker.sh` – Script to install Zigbee2MQTT via Docker
- `zigbee2mqtt_data/` – Persistent configuration and data volume
- `configuration.yaml` – Sample configuration with TCP dongle and HA integration

## 🚀 Installation

1. Ensure your MQTT broker (e.g., Mosquitto) is running at a known IP address (e.g., `192.168.1.21`).
2. Connect your Zigbee dongle:
    - For USB: plug in and determine the serial path (e.g., `/dev/ttyUSB0`)
    - For network-based dongles (e.g., SLZB-06M): ensure reachable via TCP (e.g., `tcp://192.168.1.23:6638`)
3. Update `configuration.yaml` with the appropriate serial settings.
4. Run the install script:

```bash
bash install_z2m_docker.sh
```

5. Access Zigbee2MQTT Web UI at: `http://<host-ip>:8080`

## 🔄 Home Assistant Integration

Ensure the following in `zigbee2mqtt_data/configuration.yaml`:

```yaml
mqtt:
  base_topic: zigbee2mqtt
  server: mqtt://192.168.1.21:1883
  user: mqttuser
  password: mqttpassword

homeassistant:
  enabled: true
```

In Home Assistant:

- Add the MQTT integration (if not already added)
- MQTT discovery will automatically add Zigbee devices to your dashboard
- You can monitor MQTT messages by subscribing to `zigbee2mqtt/#`

To embed Zigbee2MQTT in the Home Assistant sidebar, use a Panel iFrame pointing to `http://<host-ip>:8080`.

## 🔐 Security

- Ensure your MQTT broker uses username/password authentication.
- Restrict access to port `8080` using a firewall or Docker network.
- Set `permit_join: false` after pairing devices to protect the Zigbee mesh.

## 🛠 Troubleshooting

- If the Web UI shows the onboarding screen repeatedly, check for a valid `configuration.yaml` and TCP connection to the dongle.
- View logs with:

```bash
docker logs -f zigbee2mqtt
```

- Test TCP access to the coordinator with:

```bash
telnet <dongle-ip> 6638
```
