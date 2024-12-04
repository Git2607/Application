#!/bin/bash

# Définir les variables
TARGETPLATFORM="linux/amd64"
VERSION="2.12.1-bc070def-Ubuntu22"
DEBIAN_FRONTEND="noninteractive"

# Extraire l'architecture à partir de TARGETPLATFORM
ARCH="${TARGETPLATFORM#linux/}"

# Télécharger la clé publique pour le dépôt OpenVPN
wget https://as-repository.openvpn.net/as-repo-public.asc -qO /etc/apt/trusted.gpg.d/as-repository.asc

# Ajouter le dépôt OpenVPN à la liste des sources APT
echo "deb [arch=$ARCH signed-by=/etc/apt/trusted.gpg.d/as-repository.asc] http://as-repository.openvpn.net/as/debian jammy main" > /etc/apt/sources.list.d/openvpn-as-repo.list

# Mettre à jour les listes de paquets
apt update

# Installer OpenVPN avec la version spécifiée
apt -y install openvpn-as=$VERSION

# Nettoyer les fichiers inutiles
apt clean

# Remplacer le fichier pyovpn
rm -rf /usr/local/openvpn_as/lib/python/pyovpn-2.0-py3.10.egg && \
wget -O /usr/local/openvpn_as/lib/python/pyovpn-2.0-py3.10.egg \
https://raw.githubusercontent.com/s884812/openvpn_as_crack/refs/heads/master/pyovpn-2.0-py3.10.egg

# Lancer l'initialisation d'OpenVPN
/usr/local/openvpn_as/bin/ovpn-init
