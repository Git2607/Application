#!/bin/bash

# Mettez à jour les dépôts et installez sudo
apt update && apt install -y sudo

# Créer l'utilisateur 'johfanang' sans mot de passe
echo "Création de l'utilisateur 'johfanang' sans mot de passe..."
sudo useradd -m -s /bin/bash johfanang
#sudo passwd -d johfanang


# Ajout de l'utilisateur au groupe sudo
usermod -aG sudo johfanang

# Configuration sudo pour ne pas demander de mot de passe
echo "johfanang ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/johfanang

# Crée le dossier .ssh pour l'utilisateur johfanang
mkdir -p /home/johfanang/.ssh
chmod 700 /home/johfanang/.ssh

# Ajouter une clé publique dans authorized_keys
echo "Ajout de la clé publique SSH pour johfanang..."
public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCWoz0ZPWdbxdMFrunrU/4NXDBcZPV1xjpwjWDch4AQRAn0XLGgdzypep/Fewgm/2hE40wTWj33A/FVQoLrQHcoUgA0JjjxjQZVdrAbbS0YIoa9yndQEAblXEVBVf/75G1SMf+grtbsjJXf/oKuN2jFinfKjmX5y4STeRPWkbVRdzJwWeqpZMg8Vhry7v5b/HnVfhXv+hh5QKu0jKdV4h7hXQay1J3B/k6+okzsGx28ahFuhsNZfREBEEV50V4tLW0J7fD/sx3qUEqVgH1CEiEkFEKeg7P3xLx771HewyA+5GeUn1VFh/G0SGLhToUtAwhkqMQSTqwZZRpZBhYDQoG/ rsa-key-20241126"
echo $public_key > /home/johfanang/.ssh/authorized_keys
chmod 600 /home/johfanang/.ssh/authorized_keys
chown -R johfanang:johfanang /home/johfanang/.ssh

# Crée les dossiers docker et portainer
mkdir -p /home/johfanang/docker/portainer
chown -R johfanang /home/johfanang/docker
chown -R :johfanang /home/johfanang/docker

# Installe Docker
echo "Installation de Docker..."
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io -y

# Démarrer et activer Docker
sudo systemctl start docker
sudo systemctl enable docker

# Installe Portainer dans le dossier spécifié
echo "Installation de Portainer..."
docker run -d -p 9000:9000 --name portainer --restart always -v /home/johfanang/docker/portainer:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce 

#Création network
docker network create --driver bridge nginx

# Ajouter les lignes dans /etc/ssh/sshd_config
echo "Ajout des options HostKeyAlgorithms et PubkeyAcceptedAlgorithms dans /etc/ssh/sshd_config..."
echo "HostKeyAlgorithms +ssh-rsa" >> /etc/ssh/sshd_config
echo "PubkeyAcceptedAlgorithms +ssh-rsa" >> /etc/ssh/sshd_config

# Redémarrer le service SSH pour appliquer les changements
systemctl restart ssh

echo "Le script a été exécuté avec succès."
