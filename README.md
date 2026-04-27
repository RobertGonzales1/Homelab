# 🏠 My Homelab 2.0

Welcome To My Homelab 2.0!</br> 
2.0, born from the ashes of an accidental credential leak that claimed the original repository. RIP Homelab 1.0, Aug 2025–Apr 2026</br>
**Note:** None of the Projects Referenced in this repository is AI-Vibe Coded (as far as I know). If I discover otherwise, it will be labeled as "AI".

---

## 🖥️ Hardware

| Component | Details |
|---|---|
| Virtualization Hosts | 2× Minisforum UM690 Pro Mini PCs |
| Misc Server | 1× Dell 1L Mini PC (iMazing) |
| Network | Ubiquiti UniFi |
| Storage | Synology DS1819+ & DS1821+ (2× 8-Bay NAS) |

---

## 🛠️ Software & Infrastructure

| Category | Solution |
|---|---|
| Virtualization | Proxmox |
| Security | Cloudflare + Ubiquiti UniFi IPS |
| VM Backups | Proxmox Backup Server |
| Device Backups | Synology Active Backup for Business |

---

## 💻 Virtual Machines & Containers

- **Ubuntu Server VMs** — Cloud-Init templated, running Docker + Portainer
- **Windows Server 2022** — Rebuilt from Server 2019
- **LXC Containers** — Fully migrated to Ubuntu Server + Docker VMs ✅ *(Completed 02/2026)*

---

## 🏆 Milestones & Accomplishments

| # | Milestone | Date |
|---|---|---|
| 1 | Started documenting Homelab with Draw.IO | 08/2022 |
| 2 | Created VLANs | 12/2022 |
| 3 | Switched subnets from 192.168.x.x to 10.x.x.x | 12/2022 |
| 4 | Started using Cloudflare | 03/2023 |
| 5 | Installed CrowdSec on UniFi hardware | 04/2023 |
| 6 | Started using Backblaze B2/S3 for NAS backups | 04/2023 |
| 7 | Rebuilt Windows 10 VMs to Windows Server 2019 | 05/2023 |
| 8 | Moved domain from Google Domains to Namecheap | 11/2023 |
| 9 | Migrated to new Mini PC hardware | 08/2024 |
| 10 | Switched all Hyper-V hosts to Proxmox; rebuilt all VMs | 08/2024 |
| 11 | Started using LXC containers | 04/2025 |
| 12 | Started documenting Homelab on GitHub | 08/2025 |
| 13 | Rebuilt Windows Server 2019 VMs to Windows Server 2022 | 08/2025 |
| 14 | Reconfigured main switch and reorganized VLANs | 09/2025 |
| 15 | Created first SSH key for Cloud-Init image | 01/2026 |
| 16 | Started using custom Cloud-Init images; began rebuilding LXC containers | 01/2026 |
| 17 | Deployed family websites via Azure Static Web Apps with CI/CD from GitHub | 02/2026 |
| 18 | Implemented wildcard certificate on Nginx via DNS challenge with Cloudflare | 02/2026 |
| 19 | Completed migration of all LXC containers to Ubuntu Server + Docker | 02/2026 |
| 20 | Enabled DNSSEC on Homelab domain via Cloudflare and domain registrar | 03/2026 |
| 21 | Added Authentik SSO Solution | 03/2026 |
| 22 | Configured Authentik to Use LDAP for Jellyfin Media Server and Proxy Forward Auth for Web Based Services | 03/2026 |
| 23 | Configured Authentik to Use OAUTH2 for Immich Photo Server | 04/2026 | 
| 24 | Installed and Configured Fail2Ban on Authentik, Nginx, and Other Nginx/Internet Facing Servers | 04/2026 | 

---

## 📋 To-Do List

- [ ] Set up automation — evaluating Ansible vs. Alternatives
- [ ] Improve storage architecture — considering tiered storage array
- [ ] Implement full offsite backup strategy (Backblaze currently covers critical data only)
- [ ] Sync Pi-Hole instances or implement load balancing (exploring Kubernetes)
- [ ] Set up Home Assistant with dedicated hardware on IoT network
- [ ] Implement Proxmox HA / redundant failover once hardware allows
- [X] Add CrowdSec or Fail2Ban on NGINX and Authentik
- [ ] Setup Active Directory for Windows VMs
- [ ] Go From Testing Pi-Hole on a few Machines to Subnet-Wide Enablement
- [ ] Change BIOS Settings on VM Hosts to Auto Start After a Power Outage
- [ ] Get Dedicated Hardware for Proxmox Backup Server (Maybe Have 2 of Them for Redundancy?)
- [X] Get SSO Solution (exploring Authentik)
- [ ] Give Windows VMs Static IPs (For Ansible)
- [ ] Create Schedule/Script to Reboot Windows VMs
---

## ❔FAQ

Question: Why dont you use Cloudflare Tunnels?
Answer: I have a Video Streaming Service Plus a Photo Hosting Solution that allows Video Uploads, Both of those would Violate the Cloudflare Tunnel TOS. Also I dont want to have some services on the Tunnels and other Services using DDNS. I Decided its either one or the other for all services.

Question: Why dont you use Clustering in Proxmox?
Answer: Ive had the Clustering break in the past when ever updating one the 3 nodes I used to have, so for now no Clustering in proxmox. Maybe in the future if I get enough mini PCs going.

Question: Why do you use mini PCs and not a Racked Server?
Answer: I dont have the physical space in my house or a dedicated room for one plus the noise would keep me up at night.

Question: Why is every docker project you use in its own Linux VM?
Answer: Easier for me to backup and restore using Proxmox Backup Server. Also I dont trust Portainer one day not paywalling how many docker containers you can run in each instance.

---
## 💻 Tech Stack
AI <br> 
Used to Help With Website CSS <br>
Also Used to Help Format this Readme <br>
[![ChatGPT](https://custom-icon-badges.demolab.com/badge/ChatGPT-74aa9c?logo=openai&logoColor=white)](#)
[![Claude](https://img.shields.io/badge/Claude-D97757?logo=claude&logoColor=fff)](#) <br>

CI/CD <br>
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?logo=github-actions&logoColor=white)](#) <br>

Cloud <br>
![Backblaze](https://img.shields.io/badge/Backblaze-%23E21E29.svg?style=for-the-badge&logo=Backblaze&logoColor=white)
[![Cloudflare](https://img.shields.io/badge/Cloudflare-F38020?logo=Cloudflare&logoColor=white)](#)
![Linode](https://img.shields.io/badge/linode-00A95C?style=for-the-badge&logo=linode&logoColor=white)
[![Microsoft Azure](https://custom-icon-badges.demolab.com/badge/Microsoft%20Azure-0089D6?logo=msazure&logoColor=white)](#) <br>

Code Repository <br>
![Gitea](https://img.shields.io/badge/Gitea-34495E?style=for-the-badge&logo=gitea&logoColor=5D9425)
![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white) <br>

Education/Reference <br>
[![Google](https://img.shields.io/badge/Google-4285F4?logo=google&logoColor=white)](#)
![Reddit](https://img.shields.io/badge/Reddit-%23FF4500.svg?style=for-the-badge&logo=Reddit&logoColor=white)
[![W3Schools](https://img.shields.io/badge/W3Schools-04AA6D?logo=w3schools&logoColor=fff)](#)
[![YouTube](https://img.shields.io/badge/YouTube-%23FF0000.svg?logo=YouTube&logoColor=white)](#) <br>

Hardware <br>
![Ubiquiti](https://img.shields.io/badge/ubiquiti-%230559C9.svg?style=for-the-badge&logo=ubiquiti&logoColor=white) <br>

Framework/OS <br>
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=fff)](#)
![Portainer](https://img.shields.io/badge/portainer-%2313BEF9.svg?style=for-the-badge&logo=portainer&logoColor=white)
![Proxmox](https://img.shields.io/badge/proxmox-proxmox?style=for-the-badge&logo=proxmox&logoColor=%23E57000&labelColor=%232b2a33&color=%232b2a33)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu&logoColor=white)](#)
[![Windows](https://custom-icon-badges.demolab.com/badge/Windows-0078D6?logo=windows11&logoColor=white)](#) <br>

Programming Languages <br>
[![HTML](https://img.shields.io/badge/HTML-%23E34F26.svg?logo=html5&logoColor=white)](#)
![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=for-the-badge&logo=powershell&logoColor=white)
[![XML](https://img.shields.io/badge/XML-767C52?logo=xml&logoColor=fff)](#)
[![YAML](https://img.shields.io/badge/YAML-CB171E?logo=yaml&logoColor=fff)](#) <br>

---

## 🔗 Projects Used in This Homelab

[View my Projects Used in My Homelab on GitHub »](https://github.com/stars/RobertGonzales1/lists/used-in-my-homelab) <br>

---

## 🗺️ Network Diagram

![Network Diagram](https://raw.githubusercontent.com/RobertGonzales1/Homelab/refs/heads/main/Network%20Diagrams/Network%20Diagram%2002-11-17.png)
