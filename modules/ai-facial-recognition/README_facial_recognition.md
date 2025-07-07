
# 🧠 AI Facial Recognition with Double Take + DeepStack

This module integrates **Frigate**, **Double Take**, and **DeepStack** to provide real-time facial recognition in your smart home. When specific people are detected in camera feeds, it enables Home Assistant to trigger automations (e.g., lights, notifications, alarms).

## 📦 Components Overview

- **Frigate** – Object detection and camera stream analysis
- **DeepStack** – Lightweight local AI engine for face detection and recognition
- **Double Take** – Middleware to match Frigate snapshots against DeepStack and send matches to MQTT for Home Assistant

## 🛠️ Setup Workflow

### 1. 🚀 Provision LXC Container (Proxmox)

If using Proxmox, start by provisioning the container:

```bash
bash infrastructure/proxmox/create_lxc_faceai.sh
```

> Ensure the LXC is Debian 12, unprivileged, and has Docker & Compose installed.

### 2. 📦 Deploy Docker Stack

```bash
bash modules/ai-facial-recognition/deploy_doubletake_deepstack.sh
```

> This will install and launch DeepStack + Double Take containers.

### 3. 🔗 Access Web Interfaces

- **DeepStack**: [http://<container-ip>:5000](http://<container-ip>:5000)
- **Double Take**: [http://<container-ip>:3000](http://<container-ip>:3000)

### 4. 🧍 Enroll Faces in DeepStack

Use the API or `curl` to register known individuals:

```bash
curl -X POST http://<deepstack-ip>:5000/v1/vision/face/register \
  -F "userid=anuar" \
  -F "image=@/path/to/anuar.jpg"
```

> Run this for each user with 2–5 clear, upright, front-facing images.

### 5. 🧠 Configure Frigate + MQTT

Ensure your Frigate config has:

```yaml
mqtt:
  enabled: true
  host: mqtt.local
snapshots:
  enabled: true
  bounding_box: true
```

> Frigate sends events and face snapshots to Double Take via MQTT.

### 6. 🔄 Configure Double Take

Double Take matches Frigate snapshots with DeepStack and publishes recognized faces to MQTT:

```yaml
mqtt:
  host: mqtt.local
  topic: double-take/recognized

frigate:
  url: http://frigate:5000

detectors:
  deepstack:
    url: http://deepstack:5000
```

## 📁 Folder Structure

```
modules/ai-facial-recognition/
├── docker-compose.yml
├── deploy_doubletake_deepstack.sh
├── config/
│   └── double-take/
│       └── config.yml
└── README_deepstack_facial_recognition.md
```

## 🧪 Example Home Assistant Automation

```yaml
trigger:
  - platform: mqtt
    topic: double-take/recognized

condition:
  - condition: template
    value_template: "{{ trigger.payload_json.name == 'anuar' }}"

action:
  - service: light.turn_on
    target:
      entity_id: light.living_room
```

---

MIT License © Anuar Hill
