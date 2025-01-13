# Télécharger l'installateur CUDA 12.0.1
echo "Téléchargement de l'installateur CUDA 12.0.1..."
wget https://developer.download.nvidia.com/compute/cuda/12.0.1/local_installers/cuda_12.0.1_525.85.12_linux.run -O ~/cuda_12.0.1_525.85.12_linux.run

# Instructions pour exécuter l'installation
echo "Exécution de l'installateur CUDA. Suivez les instructions ci-dessous :"
echo "1. Acceptez le contrat de licence utilisateur final (CLUF)."
echo "2. Appuyez sur 'Space' pour désélectionner les pilotes."
echo "3. Appuyez sur 'Enter' pour commencer l'installation."

sh ~/cuda_12.0.1_525.85.12_linux.run

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
