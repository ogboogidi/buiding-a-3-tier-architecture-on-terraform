#!/bin/bash
sudo su
dnf update -y
dnf install -y httpd
cd /var/www/html
wget https://github.com/Ahmednas211/jupiter-zip-file/raw/main/jupiter-main.zip
unzip jupiter-main.zip
cp -r jupiter-main/* /var/www/html
rm -rf jupiter-main jupiter-main.zip
systemctl start httpd
systemctl enable httpd