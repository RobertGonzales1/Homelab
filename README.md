# 🏠 My Homelab

> **Note:** None of the Proects Referenced in this repository is AI-Vibe Coded (as far as I know). 
> If I discover otherwise, it will be labeled as "AI".

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
- **Windows Server 2022** — Rebuilt from Server 2019 *(Mainstream support EOL: 10/2026)*
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

---

## 📋 To-Do List

- [ ] Set up automation — evaluating Ansible vs. alternatives
- [ ] Improve storage architecture — considering tiered storage array
- [ ] Implement full offsite backup strategy (Backblaze currently covers critical data only)
- [ ] Sync Pi-Hole instances or implement load balancing (exploring Kubernetes)
- [ ] Set up Home Assistant on dedicated IoT network hardware
- [ ] Implement Proxmox HA / redundant failover once hardware allows

---

## 💻 Tech Stack

![Proxmox](https://img.shields.io/badge/proxmox-proxmox?style=for-the-badge&logo=proxmox&logoColor=%23E57000&labelColor=%232b2a33&color=%232b2a33)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Linode](https://img.shields.io/badge/linode-00A95C?style=for-the-badge&logo=linode&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Portainer](https://img.shields.io/badge/portainer-%2313BEF9.svg?style=for-the-badge&logo=portainer&logoColor=white)
![Cloudflare](https://img.shields.io/badge/Cloudflare-F38020?style=for-the-badge&logo=Cloudflare&logoColor=white)
![Nginx Proxy Manager](https://img.shields.io/badge/nginx_proxy_manager-%23F15833.svg?style=for-the-badge&logo=nginxproxymanager&logoColor=white)
![Ubiquiti](https://img.shields.io/badge/ubiquiti-%230559C9.svg?style=for-the-badge&logo=ubiquiti&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=for-the-badge&logo=powershell&logoColor=white)
![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![Gitea](https://img.shields.io/badge/Gitea-34495E?style=for-the-badge&logo=gitea&logoColor=5D9425)
![Pi-Hole](https://img.shields.io/badge/pihole-%2396060C.svg?style=for-the-badge&logo=pi-hole&logoColor=white)
![Jellyfin](https://img.shields.io/badge/jellyfin-%23000B25.svg?style=for-the-badge&logo=Jellyfin&logoColor=00A4DC)
![Backblaze](https://img.shields.io/badge/Backblaze-%23E21E29.svg?style=for-the-badge&logo=Backblaze&logoColor=white)
![HTML5](https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white)
![Reddit](https://img.shields.io/badge/Reddit-%23FF4500.svg?style=for-the-badge&logo=Reddit&logoColor=white)
![W3 Schools](https://img.shields.io/badge/W3%20Schools-04AA6D?style=for-the-badge&logo=w3schools&logoColor=white) 

---

## 🔗 Projects Used in This Homelab

[View my starred Homelab projects on GitHub »](https://github.com/stars/RobertGonzales1/lists/used-in-my-homelab)

---

## 🗺️ Network Diagram

![Network Diagram](https://github.com/RobertGonzales1/Homelab/blob/main/Network%20Diagram%202-10-65.png?raw=true)
