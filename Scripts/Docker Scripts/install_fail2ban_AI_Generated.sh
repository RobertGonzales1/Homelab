#!/usr/bin/env bash
# =============================================================
# Fail2Ban Installation & Configuration Script
# =============================================================
# Run this on each server you want to protect.
# Supports Debian/Ubuntu. For RHEL/Fedora, swap apt for dnf.
# =============================================================

set -euo pipefail

SSH_PORT="${1:-2222}"   # Match your sshd_config Port

# Never ban these: localhost, the Ansible/Semaphore host and the admin hosts
# you SSH in from. Everything else CAN be banned, so Fail2Ban stays a backstop
# against a compromised machine on the same network.
# The addresses are not stored in this public repo. Set them before running:
#   export SEMAPHORE_IP="x.x.x.x" TRUSTED_IPS="x.x.x.x y.y.y.y"
# or set the whole list yourself with IGNORE_IPS="...".
# Same list as Homelab_Ansible/Playbooks/Linux_Fail2Ban_Set_Ignore_IPs.yml.
if [ -z "${IGNORE_IPS:-}" ]; then
    : "${SEMAPHORE_IP:?Set SEMAPHORE_IP (the Ansible/Semaphore host) or IGNORE_IPS}"
    : "${TRUSTED_IPS:?Set TRUSTED_IPS (space-separated admin hosts) or IGNORE_IPS}"
    IGNORE_IPS="127.0.0.1/8 ::1 ${SEMAPHORE_IP} ${TRUSTED_IPS}"
    # On the Semaphore host itself, Semaphore's container connects from a Docker address.
    if hostname -I 2>/dev/null | tr ' ' '\n' | grep -qxF "${SEMAPHORE_IP}"; then
        IGNORE_IPS="$IGNORE_IPS 172.16.0.0/12"
    fi
fi

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

# Never ban localhost, Semaphore or the admin hosts (see IGNORE_IPS above)
ignoreip = ${IGNORE_IPS}

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
