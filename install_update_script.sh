# Supprimer les fichiers de service et du timer
sudo rm -f /usr/lib/systemd/system/update.service
sudo rm -f /usr/lib/systemd/system/update.timer

# Supprimer le script de mise à jour
sudo rm -f /usr/local/scripts/update.sh

sudo mkdir /usr/local/scripts
cp ./update.sh /usr/local/scripts/update.sh

sudo chmod +x /usr/local/scripts/update.sh

cp ./update.service /usr/lib/systemd/system/update.service
cp ./update.timer /usr/lib/systemd/system/update.timer

sudo ln -s /usr/lib/systemd/system/update.service /etc/systemd/update.service

sudo systemctl enable update.service
sudo systemctl start update.service

sudo systemctl enable update.timer
sudo systemctl start update.timer
