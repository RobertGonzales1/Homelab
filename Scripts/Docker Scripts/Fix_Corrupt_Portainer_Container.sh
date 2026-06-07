curl -fsSL https://github.com/RobertGonzales1/Homelab/blob/3a760b58bfcc3df571fdd867395b628b5eadc45d/Scripts/Docker%20Scripts/Fix_Corrupt_Portainer_Container.sh | bash

#or

sudo docker stop portainer
sudo docker rm portainer
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts
