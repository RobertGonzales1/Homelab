curl -fsSL https://github.com/RobertGonzales1/Homelab/blob/a38d0710a0cb647d86f344ab050e6d7b1f249920/Scripts/Docker%20Scripts/Fix_Corrupt_Portainer_Container.sh | bash

#or

sudo docker stop portainer
sudo docker rm portainer
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts
