
# 🌐 Remote Access Setup for Home Assistant (Reverse Proxy + Cloudflare + Dynamic IP)

This guide describes how to securely enable **remote access** to your Home Assistant instance using a **reverse proxy**, **Cloudflare**, and a **dynamic public IP address** (i.e., no static IP from ISP).

---

## 🛠️ Recommended Architecture

```
Internet 🌍
   │
[Cloudflare DNS + DDNS Updater]
   │
[Firewall (OPNsense) Port Forwarding - 80/443]
   │
[Reverse Proxy (NGINX Proxy Manager in Docker/LXC)]
   │
[Home Assistant Container @ 8123]
```

---

## ✅ Prerequisites

- Home broadband connection with dynamic public IP
- Domain name (e.g. `example.com`) registered (e.g., GoDaddy)
- Cloudflare account (free tier)
- Home Assistant running in Docker inside an LXC
- Reverse proxy container (NGINX Proxy Manager)
- DDNS Updater (e.g. Cloudflare DDNS script, `ddclient`, or OPNsense plugin)

---

## ⚙️ Step 1: Set Up Cloudflare DNS + DDNS

1. Add your domain to Cloudflare.
2. Create an **A record** for `ha.example.com`:
   - Name: `ha`
   - Target: your current public IP
   - Proxy status: **Proxied (orange cloud)**
3. Set SSL mode to: **Full** in Cloudflare > SSL/TLS.

4. Set up a DDNS client:
   - Option A: Use OPNsense’s built-in **Dynamic DNS** plugin.
   - Option B: Use a Cloudflare DDNS script in a container or scheduled job.

---

## 🧰 Step 2: Deploy NGINX Proxy Manager

```bash
docker run -d \
  --name=nginx-proxy-manager \
  -p 80:80 -p 81:81 -p 443:443 \
  -v $PWD/data:/data \
  -v $PWD/letsencrypt:/etc/letsencrypt \
  --restart unless-stopped \
  jc21/nginx-proxy-manager:latest
```

Access the UI at: `http://<reverse-proxy-ip>:81`  
Default login: `admin@example.com / changeme`

---

## 🌐 Step 3: Add Proxy Host for Home Assistant

1. NPM UI → Proxy Hosts → Add Proxy Host
2. Domain Names: `ha.example.com`
3. Scheme: `http`
4. Forward Hostname/IP: HA container IP (e.g., `192.168.x.x`)
5. Forward Port: `8123`
6. Enable:
   - [x] Block Common Exploits
   - [x] Websockets Support
7. SSL Tab:
   - Request Let’s Encrypt certificate
   - [x] Force SSL
   - [x] HTTP/2 Support

---

## 🔧 Step 4: Update Home Assistant Config

In `configuration.yaml`:

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 192.168.x.x  # IP of NGINX Proxy Manager
    - 172.18.0.0/16  # Docker subnet (optional)
```

Restart Home Assistant:

```bash
docker restart home-assistant
```

---

## 🛡️ Step 5: OPNsense Firewall Rules

1. NAT Port Forwarding:
   - WAN 80 → NPM IP 80
   - WAN 443 → NPM IP 443
2. Allow firewall rules for ports 80 and 443
3. Block WAN access to port 8123

---

## 🌩️ Step 6: Secure Cloudflare

- Enable **Bot Fight Mode**, **WAF**, and IP filtering
- Add **Access Rules** (country, IP allowlisting)

---

## 🔄 Step 7: Keep DNS in Sync with Dynamic IP

Make sure your DDNS updater regularly updates the A record in Cloudflare so `ha.example.com` always points to your current public IP.

---

## 🧪 Test Your Setup

From outside your network:

```bash
curl -I https://ha.example.com
```

Expected:

```http
HTTP/2 200 OK
```

---

## 📎 Notes

- Port 8123 remains internal; only 443 (HTTPS) is exposed
- Use Let’s Encrypt for SSL via NGINX Proxy Manager
- DDNS ensures your domain always points to the right IP

---

## 📖 References

- [Cloudflare Dynamic DNS GitHub Scripts](https://github.com/oznu/cloudflare-dns)
- [OPNsense Dynamic DNS Setup](https://docs.opnsense.org/manual/how-tos/ddns.html)
- [NGINX Proxy Manager](https://nginxproxymanager.com/)
- [Home Assistant Reverse Proxy Guide](https://www.home-assistant.io/docs/ecosystem/nginx/)
