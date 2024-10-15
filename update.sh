#!/bin/bash

# Définition des variables pour les fichiers de log
DATE=$(date +"%d%m%Y")
LOG_DIR="/var/log/update"
LOG_FILE="${LOG_DIR}/${DATE}-update.log"
ARCHIVE_NAME="${DATE}-update.tar"

# Fonction pour afficher et enregistrer les messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Vérification des privilèges root
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root" 
   exit 1
fi

# Création du répertoire de log s'il n'existe pas
mkdir -p "$LOG_DIR"

# Début du script
log_message "Début de la maintenance du système"

# Mise à jour de la liste des paquets
log_message "Mise à jour de la liste des paquets..."
apt-get update >> "$LOG_FILE" 2>&1

# Mise à jour des paquets
log_message "Mise à jour des paquets..."
apt-get upgrade -y >> "$LOG_FILE" 2>&1

# Suppression des paquets obsolètes
log_message "Suppression des paquets obsolètes..."
apt-get autoremove -y >> "$LOG_FILE" 2>&1

# Nettoyage du cache APT
log_message "Nettoyage du cache APT..."
apt-get clean >> "$LOG_FILE" 2>&1

# Mise à jour de la base de données des fichiers
if command -v updatedb &> /dev/null; then
    log_message "Mise à jour de la base de données des fichiers..."
    updatedb >> "$LOG_FILE" 2>&1
else
    log_message "La commande updatedb n'est pas disponible. Installation de mlocate..."
    apt-get install -y mlocate >> "$LOG_FILE" 2>&1
    updatedb >> "$LOG_FILE" 2>&1
fi

# Vérification et réparation des systèmes de fichiers
log_message "Vérification et réparation des systèmes de fichiers..."
for fs in $(mount | grep -E '(ext[234]|xfs)' | cut -d' ' -f1)
do
    log_message "Vérification de $fs"
    if [ "$(stat -f -c %T $fs)" = "ext4" ]; then
        tune2fs -l $fs | grep -q "^Filesystem features:.*needs_recovery" && \
        log_message "Le système de fichiers $fs nécessite une vérification au prochain redémarrage." || \
        log_message "Le système de fichiers $fs semble en bon état."
    else
        log_message "Le système de fichiers $fs n'est pas ext4, vérification ignorée."
    fi
done

# Nettoyage des fichiers temporaires
log_message "Nettoyage des fichiers temporaires..."
find /tmp -type f -atime +10 -delete
find /var/tmp -type f -atime +10 -delete

# Nettoyage des journaux anciens
log_message "Nettoyage des journaux anciens..."
journalctl --vacuum-time=30d >> "$LOG_FILE" 2>&1

# Nettoyage des fichiers de log de plus de 7 jours
log_message "Nettoyage des anciens fichiers de log des updates (plus de 7 jours)..."
find /var/log/update/ -type f -name "*.log" -mtime +7 -exec rm {} \;

# Mise à jour des microcodes CPU si nécessaire
if [ -e /sys/devices/system/cpu/microcode/reload ]; then
    log_message "Mise à jour des microcodes CPU..."
    echo 1 > /sys/devices/system/cpu/microcode/reload
fi

# Vérification des mises à jour de sécurité
log_message "Vérification des mises à jour de sécurité..."
apt-get upgrade -s | grep -i security >> "$LOG_FILE" 2>&1

# Optimisation de la base de données des paquets
log_message "Optimisation de la base de données des paquets..."
apt-get check >> "$LOG_FILE" 2>&1

# Vérification de l'intégrité des paquets installés
log_message "Vérification de l'intégrité des paquets installés..."
dpkg --audit >> "$LOG_FILE" 2>&1

# Nettoyage des anciens noyaux
log_message "Nettoyage des anciens noyaux..."
apt-get autoremove --purge -y >> "$LOG_FILE" 2>&1

# Mise à jour de la base de données GRUB
if command -v update-grub &> /dev/null; then
    log_message "Mise à jour de la base de données GRUB..."
    update-grub >> "$LOG_FILE" 2>&1
else
    log_message "La commande update-grub n'est pas disponible. Vérifiez si GRUB est installé."
fi

log_message "Maintenance terminée."

# Archivage du fichier de log à 17h
if [ "$(date +%H)" = "17" ]; then
    log_message "Archivage du fichier de log..."
    tar -cvf "${LOG_DIR}/${ARCHIVE_NAME}" -C "$LOG_DIR" "${DATE}-update.log"
    if [ $? -eq 0 ]; then
        log_message "Archivage réussi. Suppression du fichier de log original."
        rm "${LOG_FILE}"
    else
        log_message "Échec de l'archivage. Le fichier de log original est conservé."
    fi
fi
