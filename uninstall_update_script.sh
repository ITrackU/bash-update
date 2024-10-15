#!/bin/bash

# Vérification des privilèges root
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root"
   exit 1
fi

# Arrêter et désactiver les services et timers
echo "Arrêt et désactivation du service et du timer de mise à jour..."
sudo systemctl stop update.timer
sudo systemctl disable update.timer

sudo systemctl stop update.service
sudo systemctl disable update.service

# Suppression des fichiers de service et du timer
echo "Suppression des fichiers de service et de timer..."
sudo rm /usr/lib/systemd/system/update.service
sudo rm /usr/lib/systemd/system/update.timer

# Suppression des scripts
echo "Suppression du script de mise à jour..."
sudo rm /usr/local/scripts/update.sh

# Suppression des liens symboliques (si existants)
echo "Suppression des liens symboliques du service..."
sudo rm /etc/systemd/update.service 2>/dev/null

# Recharger les daemons systemd pour appliquer les changements
echo "Rechargement de systemd..."
sudo systemctl daemon-reload

# Nettoyage des fichiers de log
echo "Suppression des fichiers de log de mise à jour..."
sudo rm -rf /var/log/update

# Terminé
echo "Désinstallation terminée. Le service et le script de mise à jour ont été supprimés."
