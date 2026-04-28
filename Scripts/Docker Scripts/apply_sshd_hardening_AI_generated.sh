#!/usr/bin/env bash
# =============================================================
# Paste this entire script into an SSH session to apply
# a hardened sshd_config. It backs up your current config first.
#
# IMPORTANT: Make sure SSH key auth is working BEFORE running
# this, or you WILL lock yourself out.
# =============================================================
set -euo pipefail

echo "=== SSH Hardening Script ==="
echo ""

# Safety check
read -rp "Have you confirmed SSH key auth works for this host? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
    echo "Aborting. Set up key auth first, then re-run this script."
    exit 1
fi

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
# AllowUsers robert
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

# Restart sshd
echo "[*] Restarting sshd..."
sudo systemctl restart sshd

echo ""
echo "[✓] Done! SSH is now hardened on port 2222."
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
