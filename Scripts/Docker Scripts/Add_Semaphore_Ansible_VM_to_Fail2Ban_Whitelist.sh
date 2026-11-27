#!/bin/bash
# Run this on each VM to unban and whitelist Semaphore
#
# Semaphore's address is not stored in this public repo. Set it before running:
#   export SEMAPHORE_IP="x.x.x.x"
: "${SEMAPHORE_IP:?Set SEMAPHORE_IP to the Ansible/Semaphore host address}"

# Unban from all jails
for jail in $(sudo fail2ban-client status | grep 'Jail list' | sed 's/.*://;s/,//g'); do
  sudo fail2ban-client set $jail unbanip "$SEMAPHORE_IP" 2>/dev/null
done

# Remove iptables REJECT rules
while sudo iptables -D FORWARD -s "$SEMAPHORE_IP" -j REJECT --reject-with icmp-port-unreachable 2>/dev/null; do :; done
while sudo iptables -D INPUT -s "$SEMAPHORE_IP" -j REJECT --reject-with icmp-port-unreachable 2>/dev/null; do :; done

# Whitelist in fail2ban
if [ -f /etc/fail2ban/jail.local ]; then
  if grep -q 'ignoreip' /etc/fail2ban/jail.local; then
    if ! grep -qF "$SEMAPHORE_IP" /etc/fail2ban/jail.local; then
      sudo sed -i "s/^ignoreip = /ignoreip = $SEMAPHORE_IP /" /etc/fail2ban/jail.local
    fi
  else
    echo -e "\n[DEFAULT]\nignoreip = 127.0.0.1/8 $SEMAPHORE_IP" | sudo tee -a /etc/fail2ban/jail.local > /dev/null
  fi
else
  echo -e "[DEFAULT]\nignoreip = 127.0.0.1/8 $SEMAPHORE_IP" | sudo tee /etc/fail2ban/jail.local > /dev/null
fi

sudo fail2ban-client reload
echo "Done - Semaphore ($SEMAPHORE_IP) unbanned and whitelisted"
