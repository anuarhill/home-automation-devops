#!/bin/bash
# LXC container creation script

pct create 305 /var/lib/vz/template/cache/debian-12-standard_12.7-1_amd64.tar.zst \
--hostname ha-docker5 \
--cores 2 \
--memory 8192 \
--net0 name=eth0,bridge=vmbr0,ip=dhcp \
--rootfs local-lvm:8 \
--features nesting=1 \
--unprivileged 1 \
--start 1

