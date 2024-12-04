#!/bin/bash

# Vérifier si le script est exécuté par root
if [[ $EUID -ne 0 ]]; then
  echo "Ce script doit être exécuté en tant que root." 1>&2
  exit 1
fi

# Installer `expect` si non présent
if ! command -v expect &> /dev/null; then
  echo "Installation de l'outil 'expect' pour l'automatisation..."
  apt update && apt install -y expect
fi

# Bascule vers l'utilisateur johfanang
echo "Bascule vers l'utilisateur 'johfanang' pour l'installation."
su - johfanang <<'EOF'

# Télécharger l'installateur CUDA 12.0.1
echo "Téléchargement de l'installateur CUDA 12.0.1..."
wget https://developer.download.nvidia.com/compute/cuda/12.0.1/local_installers/cuda_12.0.1_525.85.12_linux.run -O ~/cuda_12.0.1_525.85.12_linux.run

# Créer un script `expect` pour l'installation automatique
cat > ~/install_cuda_expect.sh <<'EOL'
#!/usr/bin/expect

# Lancer l'installateur CUDA
spawn sh ~/cuda_12.0.1_525.85.12_linux.run

# Accepter le CLUF
expect "accept/decline/quit" {
    send "accept\r"
}

# Naviguer pour désélectionner les pilotes
expect "Install NVIDIA Accelerated Graphics Driver" {
    send " "
}

# Démarrer l'installation
expect "Install" {
    send "\r"
}

# Attendre la fin de l'installation
expect eof
EOL

# Donner les permissions au script `expect` et l'exécuter
chmod +x ~/install_cuda_expect.sh
echo "Lancement de l'installation automatisée de CUDA..."
~/install_cuda_expect.sh

# Supprimer le script `expect` après utilisation
rm ~/install_cuda_expect.sh

# Configurer les variables d'environnement
echo "Configuration des variables d'environnement pour CUDA 12.0..."
echo "export PATH=/usr/local/cuda-12.0/bin${PATH:+:${PATH}}" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda-12.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc
source ~/.bashrc

# Vérification de l'installation
echo "Vérification de l'installation de CUDA..."
nvcc --version

echo "Installation de CUDA 12.0 terminée avec succès !"
EOF
