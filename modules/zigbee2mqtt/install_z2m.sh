#!/bin/bash
# Zigbee2MQTT Docker install script for network-based Zigbee dongles

# Update this to match your Zigbee dongle IP and port
ZIGBEE_ETHERNET_HOST=192.168.1.23
ZIGBEE_ETHERNET_PORT=6638  # Default for SLZB-06M

# Create persistent data directory
mkdir -p zigbee2mqtt_data

# Run Zigbee2MQTT Docker container (no USB device required)
docker run -d \
  --name zigbee2mqtt2 \
  --restart unless-stopped \
  -v $(pwd)/zigbee2mqtt_data:/app/data \
  -v /etc/localtime:/etc/localtime:ro \
  -p 8080:8080 \
  koenkk/zigbee2mqtt

echo ""
echo "✅ Zigbee2MQTT container started."
echo "👉 Next step: edit zigbee2mqtt_data/configuration.yaml with:"
echo ""
echo "serial:"
echo "  port: 'tcp://${ZIGBEE_ETHERNET_HOST}:${ZIGBEE_ETHERNET_PORT}'"
echo "  adapter: ezsp"
echo ""
echo "Then restart Zigbee2MQTT with:"
echo "  docker restart zigbee2mqtt"
echo ""
echo "Access the Zigbee2MQTT Web UI at: http://localhost:8080"
