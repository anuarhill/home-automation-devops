#!/bin/bash
# Create an LXC container in Proxmox with Debian 12 standard image


set -e

read -p "Enter container number (leave blank for auto-assignment): " CTID
if [[ -z "$CTID" ]]; then
    # Find an unused CTID in the 300 series
    for i in {300..399}; do
        if ! pct status $i &>/dev/null; then
            CTID=$i
            echo "Auto-assigned container number: $CTID"
            break
        fi
    done
    if [[ -z "$CTID" ]]; then
        echo "No available container numbers in the 300 series."
        exit 1
    fi
fi


read -p "Enter hostname for the container: " HOSTNAME
if [[ -z "$HOSTNAME" ]]; then
    HOSTNAME="debian12-lxc"
    echo "No hostname entered. Using default: $HOSTNAME"
fi
# Check if the container number is already in use
if pct status "$CTID" &>/dev/null; then
    echo "Error: Container ID $CTID is already in use." 
    exit 1
fi
echo "Creating LXC container with CTID $CTID and hostname $HOSTNAME..."
# Create the container using the Debian 12 standard template
# Ensure the template exists in /var/lib/vz/template/cache/
if [[ ! -f /var/lib/vz/template/cache/debian-12-standard_12.7-1_amd64.tar.zst ]]; then
    echo "Error: Debian 12 standard template not found."
    echo "Please download the template from Proxmox repository or ensure it exists in /var/lib/vz/template/cache/"
    exit 1
fi  


pct create "$CTID" local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst \
    --hostname "$HOSTNAME" \
    --cores 2 \
    --memory 2048 \
    --swap 512 \
    --net0 name=eth0,bridge=vmbr0,ip=dhcp \
    --rootfs local-lvm:8 \
    --password yourpassword \
    --unprivileged 1 \
    --features nesting=1,keyctl=1 \
    --start 0

echo "Starting container..."
pct start $CTID

echo "Container $CTID ($HOSTNAME) created and started."
echo "Next steps:"
echo "1. Enter the container: pct exec $CTID -- bash"
echo "2. Install stack using: bash modules/monitoring/install_monitoring_stack.sh"