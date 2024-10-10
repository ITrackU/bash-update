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
