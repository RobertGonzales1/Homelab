#!/usr/bin/env bash
# =============================================================
# Paste this entire script into an SSH session to apply
# a hardened sshd_config. It backs up your current config first.
#
# IMPORTANT: Make sure SSH key auth is working BEFORE running
# this, or you WILL lock yourself out.
# =============================================================
set -euo pipefail

# The networks are not stored in this public repo. Set them before running:
#   export SSH_ALLOW_CIDR="x.x.x.x/yy"       # the only network SSH accepts logins from
#   export SSH_DENY_ADDRS="x.x.x.x,y.y.y.y"  # hosts inside it that must not log in
#                                            # (e.g. VPN routers); "none" skips this
: "${SSH_ALLOW_CIDR:?Set SSH_ALLOW_CIDR, e.g. export SSH_ALLOW_CIDR=192.168.1.0/24}"
: "${SSH_DENY_ADDRS:?Set SSH_DENY_ADDRS (comma-separated) or SSH_DENY_ADDRS=none}"

echo "=== SSH Hardening Script ==="
echo ""
echo "[!] WARNING: This disables password auth. Make sure key auth works first!"
echo ""

# Back up existing config
BACKUP="/etc/ssh/sshd_config.bak.$(date +%Y%m%d%H%M%S)"
echo "[*] Backing up current config to $BACKUP"
sudo cp /etc/ssh/sshd_config "$BACKUP"

# Write the hardened config
echo "[*] Writing hardened sshd_config..."
sudo tee /etc/ssh/sshd_config > /dev/null << 'SSHEOF'
# --- Network ---
Port 2222
AddressFamily inet
ListenAddress 0.0.0.0

# --- Protocol ---
Protocol 2

# --- Authentication ---
PermitRootLogin no
MaxAuthTries 3
LoginGraceTime 30
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
AuthenticationMethods publickey

# --- Restrict Users (uncomment and edit) ---
# AllowUsers youruser
# AllowGroups ssh-users

# --- Key Exchange & Ciphers ---
KexAlgorithms sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
HostKeyAlgorithms ssh-ed25519,rsa-sha2-512,rsa-sha2-256

# --- Session ---
ClientAliveInterval 300
ClientAliveCountMax 2
MaxSessions 3
MaxStartups 3:50:10

# --- Forwarding & Tunnels ---
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
PermitTunnel no
GatewayPorts no

# --- Logging ---
SyslogFacility AUTH
LogLevel VERBOSE

# --- Misc ---
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
PermitUserEnvironment no
Compression no
StrictModes yes

SSHEOF

# --- Homelab only: refuse logins from outside SSH_ALLOW_CIDR ---
# ...and from the hosts in SSH_DENY_ADDRS. Must stay LAST: everything after a
# Match line applies only to that match. Same block (same markers) the
# SSH_Allow_Homelab_Only Ansible playbook manages.
{
    echo "# BEGIN ANSIBLE homelab-only SSH (Homelab_Ansible/Playbooks/SSH_Allow_Homelab_Only.yml)"
    echo "Match Address *,!${SSH_ALLOW_CIDR},!127.0.0.0/8,!::1"
    echo "    DenyUsers *"
    if [ "${SSH_DENY_ADDRS}" != "none" ]; then
        echo "Match Address ${SSH_DENY_ADDRS}"
        echo "    DenyUsers *"
    fi
    echo "# END ANSIBLE homelab-only SSH (Homelab_Ansible/Playbooks/SSH_Allow_Homelab_Only.yml)"
} | sudo tee -a /etc/ssh/sshd_config > /dev/null

# With socket activation (Ubuntu 24.04) /run/sshd may not exist yet,
# and sshd -t refuses to run without it.
sudo mkdir -p /run/sshd

# Validate the config before restarting
echo "[*] Validating config..."
if sudo sshd -t; then
    echo "[✓] Config is valid."
else
    echo "[✗] Config validation failed! Restoring backup..."
    sudo cp "$BACKUP" /etc/ssh/sshd_config
    echo "[!] Original config restored. Fix the errors and try again."
    exit 1
fi

# Restart sshd. Ubuntu 24.04 names the service "ssh" and listens through
# ssh.socket (whose port is generated from sshd_config on daemon-reload).
echo "[*] Restarting sshd..."
sudo systemctl daemon-reload
if systemctl is-enabled --quiet ssh.socket 2>/dev/null; then
    sudo systemctl restart ssh.socket
fi
if systemctl is-active --quiet ssh.service; then
    sudo systemctl restart ssh.service
elif systemctl is-active --quiet sshd.service; then
    sudo systemctl restart sshd.service
fi

echo ""
echo "[✓] Done! SSH is now hardened on port 2222 and only accepts logins from ${SSH_ALLOW_CIDR}."
echo ""
echo "    ╔══════════════════════════════════════════════════╗"
echo "    ║  DO NOT close this session yet!                  ║"
echo "    ║  Open a NEW terminal and test:                   ║"
echo "    ║    ssh -p 2222 -i ~/.ssh/your_key user@this-host ║"
echo "    ║  If it works, you're good. If not, you still     ║"
echo "    ║  have this session to fix things.                ║"
echo "    ╚══════════════════════════════════════════════════╝"
echo ""
echo "    Backup saved at: $BACKUP"
