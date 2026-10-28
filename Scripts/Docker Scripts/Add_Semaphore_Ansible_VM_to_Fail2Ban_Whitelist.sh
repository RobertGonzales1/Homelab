#!/bin/bash
# Run this on each VM to unban and whitelist Semaphore

# Unban from all jails
for jail in $(sudo fail2ban-client status | grep 'Jail list' | sed 's/.*://;s/,//g'); do
  sudo fail2ban-client set $jail unbanip x.x.x.x 2>/dev/null
done

# Remove iptables REJECT rules
while sudo iptables -D FORWARD -s x.x.x.x -j REJECT --reject-with icmp-port-unreachable 2>/dev/null; do :; done
while sudo iptables -D INPUT -s x.x.x.x -j REJECT --reject-with icmp-port-unreachable 2>/dev/null; do :; done

# Whitelist in fail2ban
if [ -f /etc/fail2ban/jail.local ]; then
  if grep -q 'ignoreip' /etc/fail2ban/jail.local; then
    if ! grep -q 'x.x.x.x' /etc/fail2ban/jail.local; then
      sudo sed -i 's/^ignoreip = /ignoreip = x.x.x.x /' /etc/fail2ban/jail.local
    fi
  else
    echo -e '\n[DEFAULT]\nignoreip = 127.0.0.1/8 x.x.x.x' | sudo tee -a /etc/fail2ban/jail.local > /dev/null
  fi
else
  echo -e '[DEFAULT]\nignoreip = 127.0.0.1/8 x.x.x.x' | sudo tee /etc/fail2ban/jail.local > /dev/null
fi

sudo fail2ban-client reload
echo "Done - Semaphore (x.x.x.x) unbanned and whitelisted"
