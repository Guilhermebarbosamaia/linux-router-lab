#!/bin/bash

# ==============================
# Linux Router Setup Script
# ==============================

echo "[+] Starting router configuration..."

# Interfaces (ajuste se necessário)
WAN="ens33"   # Internet (NAT)
LAN="ens37"   # LAN Segment

# ==============================
# Enable IP Forwarding
# ==============================
echo "[+] Enabling IP forwarding..."

sudo sysctl -w net.ipv4.ip_forward=1

# Persist after reboot
if ! grep -q "net.ipv4.ip_forward=1" /etc/sysctl.conf; then
    echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
fi

# ==============================
# Flush old iptables rules
# ==============================
echo "[+] Cleaning old iptables rules..."

sudo iptables -F
sudo iptables -t nat -F

# ==============================
# Configure NAT
# ==============================
echo "[+] Configuring NAT..."

sudo iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE

# ==============================
# Configure Forwarding Rules
# ==============================
echo "[+] Setting forwarding rules..."

sudo iptables -A FORWARD -i $WAN -o $LAN -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $LAN -o $WAN -j ACCEPT

# ==============================
# Done
# ==============================
echo "[+] Router setup completed successfully!"