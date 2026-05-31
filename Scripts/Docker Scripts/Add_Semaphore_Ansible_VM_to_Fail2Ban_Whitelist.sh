#!/bin/bash
# Run this on each VM to unban and whitelist Semaphore

# Unban from all jails
for jail in $(sudo fail2ban-client status | grep 'Jail list' | sed 's/.*://;s/,//g'); do
  sudo fail2ban-client set $jail unbanip 10.30.1.19 2>/dev/null
done

# Remove iptables REJECT rules
while sudo iptables -D FORWARD -s 10.30.1.19 -j REJECT --reject-with icmp-port-unreachable 2>/dev/null; do :; done
while sudo iptables -D INPUT -s 10.30.1.19 -j REJECT --reject-with icmp-port-unreachable 2>/dev/null; do :; done

# Whitelist in fail2ban
if [ -f /etc/fail2ban/jail.local ]; then
  if grep -q 'ignoreip' /etc/fail2ban/jail.local; then
    if ! grep -q '10.30.1.19' /etc/fail2ban/jail.local; then
      sudo sed -i 's/^ignoreip = /ignoreip = 10.30.1.19 /' /etc/fail2ban/jail.local
    fi
  else
    echo -e '\n[DEFAULT]\nignoreip = 127.0.0.1/8 10.30.1.19' | sudo tee -a /etc/fail2ban/jail.local > /dev/null
  fi
else
  echo -e '[DEFAULT]\nignoreip = 127.0.0.1/8 10.30.1.19' | sudo tee /etc/fail2ban/jail.local > /dev/null
fi

sudo fail2ban-client reload
echo "Done - Semaphore (10.30.1.19) unbanned and whitelisted"
