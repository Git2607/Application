#!/bin/bash

# Changer d'utilisateur
echo "Changement d'utilisateur vers 'johfanang'"
su johfanang <<'EOF'

# Télécharger l'installateur CUDA 12.0.1
echo "Téléchargement de l'installateur CUDA 12.0.1..."
wget https://developer.download.nvidia.com/compute/cuda/12.0.1/local_installers/cuda_12.0.1_525.85.12_linux.run -O ~/cuda_12.0.1_525.85.12_linux.run

EOF

# Exécuter le fichier d'installation
echo "Exécution de l'installateur CUDA..."
sudo sh /home/johfanang/cuda_12.0.1_525.85.12_linux.run --silent --toolkit

# Configurer les variables d'environnement
echo "Configuration des variables d'environnement pour CUDA 12.0..."
echo "export PATH=/usr/local/cuda-12.0/bin${PATH:+:${PATH}}" >> /home/pythonuser/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda-12.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> /home/pythonuser/.bashrc
source /home/pythonuser/.bashrc

# Vérification de l'installation
echo "Vérification de l'installation de CUDA..."
nvcc --version

echo "Installation de CUDA 12.0 terminée avec succès !"
