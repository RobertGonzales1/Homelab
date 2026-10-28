#!/usr/bin/env bash
# =============================================================
# Paste this entire script into an SSH session to apply
# kernel-level network hardening via sysctl.
# =============================================================
set -euo pipefail

echo "=== Sysctl Hardening Script ==="
echo ""

# Write the hardening config
echo "[*] Writing /etc/sysctl.d/99-hardening.conf..."
sudo tee /etc/sysctl.d/99-hardening.conf > /dev/null << 'SYSEOF'
# --- IP Spoofing Protection ---
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# --- Disable source routing ---
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0

# --- Disable ICMP redirects (prevents MITM) ---
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv6.conf.all.accept_redirects = 0

# --- Ignore ICMP broadcasts (prevents Smurf attacks) ---
net.ipv4.icmp_echo_ignore_broadcasts = 1

# --- Ignore bogus ICMP error responses ---
net.ipv4.icmp_ignore_bogus_error_responses = 1

# --- SYN flood protection ---
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2

# --- Log suspicious packets ---
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# --- Prevent core dumps ---
fs.suid_dumpable = 0

# --- Randomize memory layout (ASLR) ---
kernel.randomize_va_space = 2

# --- Restrict access to kernel logs ---
kernel.dmesg_restrict = 1

# --- Restrict access to kernel pointers ---
kernel.kptr_restrict = 2
SYSEOF

# Apply immediately
echo "[*] Applying sysctl settings..."
sudo sysctl --system

echo ""
echo "[✓] Done! Kernel hardening is active and will persist across reboots."
echo ""
echo "    To verify a setting:  sysctl net.ipv4.conf.all.rp_filter"
echo "    To see all changes:   sysctl -a | grep -E 'rp_filter|syncookies|redirects'"
