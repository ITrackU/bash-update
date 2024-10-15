Linux Auto-Update Script

Description

Ce projet fournit un script  et des services Systemd pour automatiser les mises à jour du système sous Linux. Il effectue les tâches de maintenance courantes, y compris les mises à jour des paquets, le nettoyage des fichiers temporaires, et la vérification de l'intégrité du système. Le processus est planifié pour s'exécuter automatiquement à différentes heures de la journée.
Fonctionnalités

  Mise à jour automatique des paquets et du système.
  Nettoyage des paquets obsolètes et des fichiers temporaires.
  Vérification et réparation des systèmes de fichiers.
  Archivage quotidien des fichiers de logs.
  Planification automatique via un timer Systemd.

Prérequis

  Distribution Linux basée sur Debian/Ubuntu.
  Accès root (administrateur).
  Systemd pour la gestion des services et des timers.

Installation
Étape 1 : Rendre le script d'installation exécutable

Avant de lancer le script d'installation, il faut s'assurer qu'il est exécutable. Utilisez la commande suivante :

    chmod +x install_update_script.sh

Étape 2 : Installer le script et les fichiers de service

Une fois le script rendu exécutable, exécutez-le pour installer le script de mise à jour et les fichiers de service Systemd.

    sudo ./install_update_script.sh

Ce script :

  Copie le script update.sh dans /usr/local/scripts/.
  Assigne les permissions d'exécution au script.
  Installe les fichiers update.service et update.timer dans /usr/lib/systemd/system/.
  Active et démarre les services et timers nécessaires.

Étape 3 : Activer et démarrer les services

Après l'installation, les services et timers Systemd sont automatiquement activés. Si vous devez les démarrer manuellement, exécutez les commandes suivantes :

    sudo systemctl enable update.service
    sudo systemctl start update.service

    sudo systemctl enable update.timer
    sudo systemctl start update.timer

Étape 4 : Vérification

Vous pouvez vérifier que le timer est activé en utilisant la commande suivante :

    systemctl list-timers --all | grep update.timer

Fichiers inclus
update.sh

Le script  principal qui :

  Met à jour le système via apt-get update et apt-get upgrade.
  Supprime les paquets obsolètes avec apt-get autoremove.
  Nettoie le cache APT et les fichiers temporaires.
  Vérifie les systèmes de fichiers et les journaux.
  Archive les logs quotidiens à 17h.

update.service

Le service Systemd qui exécute le script de mise à jour.
update.timer

Le timer Systemd qui planifie l'exécution du service à :

    Entre minuit et 8h00.
    12h00.
    17h00.

Personnalisation

Vous pouvez ajuster le calendrier d'exécution en modifiant les lignes OnCalendar dans le fichier update.timer. Voici un exemple :

    [Timer]
    OnCalendar=*-*-* 01:00:00
    OnCalendar=*-*-* 13:00:00
    OnCalendar=*-*-* 18:00:00

Cela planifiera les mises à jour à 1h00, 13h00 et 18h00 chaque jour.
Désinstallation

Pour supprimer totalement les mises à jour automatiques par le script veuillez exécuter le script de désinstallation :

Instructions :

  Copiez ce script dans un fichier appelé uninstall_update_script.sh.

  Rendez le script exécutable avec la commande suivante :

    chmod +x uninstall_update_script.sh
    
  Exécutez le script pour désinstaller le projet :
    
    chmod +x uninstall_update_script.sh
    sudo ./uninstall_update_script.sh

Ce que fait le script :

  arrête et désactive les services et timers liés à la mise à jour automatique.
  supprime les fichiers du service (update.service) et du timer (update.timer) de Systemd.
  supprime le script de mise à jour (update.sh) dans /usr/local/scripts/.
  supprime les logs associés situés dans /var/log/update.
  recharge les daemons Systemd pour appliquer les changements.

Ainsi, le système sera entièrement nettoyé de toutes les traces de votre projet.

Logs et Dépannage

  Les logs d'exécution du script sont enregistrés dans /var/log/update/.
  Les logs du service Systemd sont disponibles dans /var/log/update-service.log.

Pour consulter les logs du timer et du service :

    sudo journalctl -u update.timer
    sudo journalctl -u update.service

*********************************************************************************************************************************
=================================        ENGLISH TRANSLATION            ================================
*********************************************************************************************************************************

Linux Auto-Update Script
Description

This project provides a script and Systemd services to automate system updates on Linux. It performs common maintenance tasks, including package updates, temporary file cleanup, and system integrity checks. The process is scheduled to run automatically at different times of the day.
Features

    Automatic system and package updates.
    Cleanup of obsolete packages and temporary files.
    File system checks and repairs.
    Daily archiving of log files.
    Automatic scheduling via a Systemd timer.

Prerequisites

    Debian/Ubuntu-based Linux distribution.
    Root (administrator) access.
    Systemd for managing services and timers.

Installation
Step 1: Make the installation script executable

Before running the installation script, ensure it is executable. Use the following command:

chmod +x install_update_script.sh

Step 2: Install the script and service files

Once the script is executable, run it to install the update script and the Systemd service files.

sudo ./install_update_script.sh

This script:

    Copies the update.sh script to /usr/local/scripts/.
    Assigns execution permissions to the script.
    Installs the update.service and update.timer files in /usr/lib/systemd/system/.
    Enables and starts the necessary services and timers.

Step 3: Enable and start the services

After installation, the Systemd services and timers are automatically enabled. If you need to start them manually, run the following commands:

sudo systemctl enable update.service
sudo systemctl start update.service

sudo systemctl enable update.timer
sudo systemctl start update.timer

Step 4: Verification

You can verify that the timer is active by using the following command:

systemctl list-timers --all | grep update.timer

Included Files
update.sh

The main script that:

    Updates the system via apt-get update and apt-get upgrade.
    Removes obsolete packages using apt-get autoremove.
    Cleans the APT cache and temporary files.
    Checks the file systems and logs.
    Archives the daily logs at 17:00.

update.service

The Systemd service that runs the update script.
update.timer

The Systemd timer that schedules the execution of the service at:

    Between midnight and 08:00.
    12:00.
    17:00.

Customization

You can adjust the execution schedule by modifying the OnCalendar lines in the update.timer file. Here’s an example:

[Timer]
OnCalendar=*-*-* 01:00:00
OnCalendar=*-*-* 13:00:00
OnCalendar=*-*-* 18:00:00

This will schedule updates at 01:00, 13:00, and 18:00 every day.
Uninstallation

To completely remove the automatic updates by the script, run the uninstallation script:
Instructions:

    Copy this script into a file called uninstall_update_script.sh.

    Make the script executable using the following command:

chmod +x uninstall_update_script.sh

    Run the script to uninstall the project:

sudo ./uninstall_update_script.sh

What the script does:

    Stops and disables the services and timers related to automatic updates.
    Removes the service files (update.service) and the timer (update.timer) from Systemd.
    Deletes the update script (update.sh) from /usr/local/scripts/.
    Removes the associated logs located in /var/log/update.
    Reloads Systemd daemons to apply the changes.

This will completely clean the system of any traces of your project.
Logs and Troubleshooting

    The script’s execution logs are saved in /var/log/update/.
    The Systemd service logs are available in /var/log/update-service.log.

To check the logs for the timer and service:

sudo journalctl -u update.timer
sudo journalctl -u update.service
