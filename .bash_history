exit
clear
df -h
lsblk
sudo pvs
sudo vgs
sudo lvs
sudo lvextend -l +100%FREE /dev/vg_name/lv_name
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
df -h
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
df -h
whatweb http://<IP-VPS>/ojs/
whatweb http://10.34.100.181/ojs/
sudo apt install whatweb
whatweb http://10.34.100.181/ojs/
sudo systemctl status apache2
ls
sudo systemctl status nginx
sudo apt update && sudo apt upgrade -y
sudo apt install -y apache2 mysql-server php7.4 php7.4-cli   php7.4-common php7.4-mysql php7.4-xml php7.4-mbstring   php7.4-gd php7.4-curl php7.4-zip php7.4-intl unzip wget
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo add-apt-repository ppa:ondrej/php
sudo apt install -y apache2 mysql-server php7.4 php7.4-cli   php7.4-common php7.4-mysql php7.4-xml php7.4-mbstring   php7.4-gd php7.4-curl php7.4-zip php7.4-intl unzip wget
cd /var/www/html
sudo wget https://pkp.sfu.ca/ojs/download/ojs-3.3.0-8.tar.gz
sudo tar -xzf ojs-3.3.0-8.tar.gz
cd /var/www/html
sudo tar -xzf ojs-3.3.0-8.tar.gz
ls
sudo mv ojs-3.3.0-8 ojs
cd /var/www/html
sudo chown -R www-data:www-data ojs
sudo chmod -R 755 ojs
sudo mysql -u root <<EOF
CREATE DATABASE ojs_db CHARACTER SET utf8mb3;
CREATE USER 'ojs_user'@'localhost' IDENTIFIED BY 'P@ssw0rd_OJS!';
GRANT ALL PRIVILEGES ON ojs_db.* TO 'ojs_user'@'localhost';
FLUSH PRIVILEGES;
EOF

sudo mysql -u root
sudo nano /etc/apache2/sites-available/ojs.conf
sudo a2ensite ojs.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
http://10.34.100.181/ojs/index.php/index/install
curl -s http://localhost/ojs/index.php/index | grep -i "ojs\|version"
sudo tail -f /var/log/apache2/ojs_access.log
cd /var/www/html
sudo nano /etc/apache2/sites-available/ojs.conf
sudo a2ensite ojs.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
