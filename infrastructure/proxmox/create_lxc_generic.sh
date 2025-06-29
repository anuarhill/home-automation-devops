#!/bin/bash
# Interactive LXC container creation script with optional CTID

# Get next available CTID using `pvesh`
get_next_ctid() {
  existing_ids=$(pct list | awk 'NR>1 {print $1}' | sort -n)
  for i in $(seq 100 999); do
    if ! echo "$existing_ids" | grep -q "^$i$"; then
      echo "$i"
      return
    fi
  done
  echo "Error: No available CTID found." >&2
  exit 1
}

read -p "Enter LXC container ID (leave blank for auto): " CTID
if [[ -z "$CTID" ]]; then
  CTID=$(get_next_ctid)
  echo "Using next available CTID: $CTID"
fi

read -p "Enter hostname for the container [default: lxc-container]: " HOSTNAME
HOSTNAME=${HOSTNAME:-lxc-container}

echo "Creating LXC container with ID: $CTID and hostname: $HOSTNAME"

pct create "$CTID" /var/lib/vz/template/cache/debian-12-standard_12.7-1_amd64.tar.zst \
  --hostname "$HOSTNAME" \
  --cores 2 \
  --memory 8192 \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp \
  --rootfs local-lvm:8 \
  --features nesting=1 \
  --unprivileged 1 \
  --start 1

if [ $? -eq 0 ]; then
  echo "✅ Container $CTID ($HOSTNAME) created and started successfully."
else
  echo "❌ Failed to create container. Please check the parameters and try again."
fi
