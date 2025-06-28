#!/bin/bash
# Script to create MQTT LXC container in Proxmox

pct create 306 /var/lib/vz/template/cache/debian-12-standard_12.7-1_amd64.tar.zst \
  --hostname mqtt-docker \
  --cores 1 \
  --memory 2048 \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp \
  --rootfs local-lvm:4 \
  --features nesting=1 \
  --unprivileged 1 \
  --start 1

echo "✅ MQTT LXC container created and started."
