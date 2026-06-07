#curl -fsSL https://raw.githubusercontent.com/RobertGonzales1/Homelab/refs/heads/main/Scripts/Docker%20Scripts/Fix_Corrupt_Portainer_Container.sh | bash
#or
sudo docker stop portainer
sudo docker rm portainer
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts
