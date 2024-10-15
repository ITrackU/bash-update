#!/bin/bash

# Vérification des privilèges root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Indiquer le début du processus d'installation
echo "Starting the installation of the auto-update script..."

# Supprimer les fichiers de service et du timer existants
echo "Removing old service and timer files..."
sudo rm -f /usr/lib/systemd/system/update.service
sudo rm -f /usr/lib/systemd/system/update.timer
sudo rm -f /etc/systemd/update.service
sudo rm -f /etc/systemd/update.timer

# Supprimer le script de mise à jour existant
echo "Removing old update script..."
sudo rm -f /usr/local/scripts/update.sh

# Créer le répertoire pour le script s'il n'existe pas
echo "Creating directory for the update script..."
sudo mkdir -p /usr/local/scripts

# Copier le nouveau script update.sh
echo "Copying new update script to /usr/local/scripts..."
cp ./update.sh /usr/local/scripts/update.sh

# Donner les permissions d'exécution au script
echo "Setting executable permissions for the update script..."
sudo chmod +x /usr/local/scripts/update.sh

# Copier les fichiers de service et de timer dans /usr/lib/systemd/system
echo "Copying service and timer files to /usr/lib/systemd/system..."
cp ./update.service /usr/lib/systemd/system/update.service
cp ./update.timer /usr/lib/systemd/system/update.timer

# Créer un lien symbolique pour les fichiers de service dans /etc/systemd
echo "Creating symbolic links for the service files in /etc/systemd..."
sudo ln -s /usr/lib/systemd/system/update.service /etc/systemd/update.service

# Activer et démarrer le service update.service
echo "Enabling and starting the update service..."
sudo systemctl enable update.service
sudo systemctl start update.service

# Activer et démarrer le timer update.timer
echo "Enabling and starting the update timer..."
sudo systemctl enable update.timer
sudo systemctl start update.timer

# Fin du processus d'installation
echo "Installation completed successfully!"
