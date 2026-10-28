#!/usr/bin/env bash
# =============================================================
# Fail2Ban Installation & Configuration Script
# =============================================================
# Run this on each server you want to protect.
# Supports Debian/Ubuntu. For RHEL/Fedora, swap apt for dnf.
# =============================================================

set -euo pipefail

SSH_PORT="${1:-2222}"   # Match your sshd_config Port

echo "=== Fail2Ban Installer for Homelab ==="
echo ""

# Install
echo "[*] Installing fail2ban..."
sudo apt-get update -qq
sudo apt-get install -y -qq fail2ban

# Create local config (overrides without touching default files)
echo "[*] Writing /etc/fail2ban/jail.local..."
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOF
[DEFAULT]
# Ban for 1 hour after 3 failures within 10 minutes
bantime  = 3600
findtime = 600
maxretry = 3
banaction = iptables-multiport
backend = systemd

# Optional: whitelist your trusted IPs so you don't lock yourself out
# ignoreip = 127.0.0.1/8 10.0.10.0/24

[sshd]
enabled  = true
port     = ${SSH_PORT}
filter   = sshd
logpath  = /var/log/auth.log
maxretry = 3
bantime  = 3600

# Aggressive repeat-offender jail
[sshd-aggressive]
enabled  = true
port     = ${SSH_PORT}
filter   = sshd[mode=aggressive]
logpath  = /var/log/auth.log
maxretry = 2
bantime  = 86400
findtime = 3600
EOF

# Enable and start
echo "[*] Enabling fail2ban..."
sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

echo ""
echo "[✓] Fail2ban is running. Check status with:"
echo "    sudo fail2ban-client status"
echo "    sudo fail2ban-client status sshd"
echo ""
echo "[*] To unban an IP:"
echo "    sudo fail2ban-client set sshd unbanip <IP>"
