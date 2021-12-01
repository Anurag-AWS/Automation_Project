#!/bin/bash

#Automation script for Apache

#INITIALIZE VARIABLES
myname=“Anurag”
s3_bucket="s3://upgrad-anurag/“

#UPDATE THE PACKAGE INFORMATION

sudo apt update -y

#Script ensures that the HTTP Apache server is installed
sudo apt-get install

# TO CHECK IF APACHE IS INSTALLED- 

dpkg --get-selections | grep apache

if [ $? -eq 0 ]; then
    echo "apache2 is installed!"
else
    echo "apache is NOT installed!"
    sudo apt install apache2
fi

#ENSURE APACHE SERVICE IS RUNNING

service apache2 restart

servstat=$(service apache2 status)

if [[ $servstat == "active (running)" ]]; then
  echo "Apache process is running"
else
echo "Apache process is not running. Starting it..."
sudo systemctl start apache2

fi

#ENSURE APACHE SERVICE IS ENABLED AT BOOT, IF NOT ENABLE IT

isenabled=$(systemctl is-enabled apache2)
if [[ $isenabled == "enabled" ]]; then
echo "Apache service is enabled at boot"
else
echo "Apache service is disabled. Enabling it..."
sudo systemctl enable apache2
fi


#MAKE TAR FILE WITH ONLY .LOG FILE FROM THE /var/log/apache2/

timestamp=$(date '+%d%m%Y-%H%M%S')
tar_filename="/tmp/"${myname}"-httpd-logs-"${timestamp}".tar"
echo $tar_filename
tar -cvf $tar_filename --absolute-names /var/log/apache2/*.log

aws s3 cp $tar_filename $s3_bucket


