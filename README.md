# My Homelab
Note: None of the Code in This Repository is AI Generated (As Far As I Know). If I find out it is, I will Label it as AI. 

It Uses Proxmox as the Virtualization Platform.

Network Hardware is Unifi

Security is a Combination of Cloudflare + Crowdsec on the NGINX + Unifi IPS (Looking to use Fail to Ban in a future Rebuild)

Storage is 2 Synology 8 bay NASs that uses CIFS (Linux VMs)/SMB and iSCSI (Windows VMs), Only Critical Data is Backed up via Backblaze B2/S3 Buckets

Backups Use Proxmox Backup Server (Proxmox VMs) + Synology Active Backup for Business (Windows Devices without VMs (Desktops, Laptops, etc...)) 

# The VMs I Use Contain:
Cloud-Int with Ubuntu Server with Docker

Windows Server 2022 (I Know its Mainstream Support is going EOL 10/2026, But I Already Rebuilt Everything from Server 2019 and didn't find out about the EOL until after I was done.)

LXC Containers (I’m trying to rebuild these one at a time into Cloud-Int with Ubuntu Server with Docker as I didn’t know the LXC containers all share the same Kernel.)

# Projects I use on are Below, check them out and Support the Projects:
[Projects Used in my Homelab](https://github.com/stars/RobertGonzales1/lists/used-in-my-homelab) (GitHub is not letting me make this link open in a new window.)

# Milestones/Accomplishments:
1. Started Documenting Homelab with Draw.IO (08/2022)
2. Created VLANs (12/2022)
3. Switched Subnets From 192.168.x.x To 10.x.x.x (12/2022)
4. Started Using Cloudflare (03/2023)
5. Get Crowdsec Installed on Unifi Hardware (04/2023)
6. Started Using Backblaze B2/S3 for NAS Data Backups (04/2023)
7. Rebuilt Most Windows 10 VMs to Windows Server 2019 (05/2023)
8. Moved Domain form Google Domains to Name Cheap (11/2023)
9. Switched to New Hardware (Mini PCs From 1L Dell PCs) (08/2024)
10. Switched all Hyper-V Hosts to Proxmox, Also Rebuilt all VMs (08/2024)
11. Started Using LXC Containers (04/2025)
12. Started Using GitHub To Document Homelab (08/2025)
13. Started Rebuilding VMs Using Windows Server 2019 into VMs Using Windows Server 2022 (08/2025) 
14. Reconfigured Main Switch, Also Moved the VLANs on the Ports around so it’s more organized (09/2025)
15. Created First SSH Key for Cloud-init Image for New VMs (01/2026)
16. Started Using Custom Made Cloud-init Image and Started to Rebuild LXC Containers into the Cloud-init Ubuntu Server VMs (01/2026)

# My TO-DO List:
1. Figure Out How to Configure Cloudflare/Nginx so my Nginx can Renew SSL Certs when I have the Proxying Turned on in the DNS for Cloudflare.
2. Have a Wildcard Cert through NGINX VS a Cert for Each Sub Domain.
3. Set Up some Automation like updates (Still need to figure out if I’m going to invest my time in Ansible, n8n, or another product).
4. Figure out a better storage solution than just 2 NASs (Maybe Tiered Storage Array?).
5. A Secondary Site Backup strategy (I have Backblaze for offsite but that just has critical data, Need an Offsite solution for all Data).
6. Figure out how to Sync my Pi-Hole Instances or do some sort of load balancing (Kubernetes?).
7. Get Home Assistant Setup (Will Need Separate Hardware Sitting on my IOT Network).
8. Transfer Main Domain to a New Provider.

# 💻 Tech Stack:
![Cloudflare](https://img.shields.io/badge/Cloudflare-F38020?style=for-the-badge&logo=Cloudflare&logoColor=white) 
![Windows Terminal](https://img.shields.io/badge/Windows%20Terminal-%234D4D4D.svg?style=for-the-badge&logo=windows-terminal&logoColor=white) 
![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=for-the-badge&logo=powershell&logoColor=white) 
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white) 
![Jellyfin](https://img.shields.io/badge/jellyfin-%23000B25.svg?style=for-the-badge&logo=Jellyfin&logoColor=00A4DC) 
![Pi-Hole](https://img.shields.io/badge/pihole-%2396060C.svg?style=for-the-badge&logo=pi-hole&logoColor=white) 
![Ubiquiti](https://img.shields.io/badge/ubiquiti-%230559C9.svg?style=for-the-badge&logo=ubiquiti&logoColor=white) 
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

<!-- Proudly created with GPRM ( https://gprm.itsvg.in ) -->
<img width="2191" height="4657" alt="Network Diagram 2-10-65" src="https://github.com/RobertGonzales1/Homelab/blob/main/Network%20Diagram%202-10-65.png?raw=true" />

