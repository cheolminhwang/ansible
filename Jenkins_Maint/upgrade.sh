#!/bin/bash

# Check Jenkins version
jenkins --version

# Stop Jenkins service
echo "Stopping Jenkins service..."
sudo systemctl status jenkins
sudo systemctl stop jenkins
echo "Jenkins service stopped."

# Get today's date in mmddyyyy format
date=$(date +"%m%d%Y")

# Taking backup of migrate
echo "Starting backup of migrate..."
sudo cp /usr/share/jenkins/migrate /usr/share/jenkins/migrate_backup_$date
echo "Completed backup of migrate."

# Taking backup of jenkins.service
echo "Starting backup of jenkins.service..."
sudo cp /usr/lib/systemd/system/jenkins.service /usr/lib/systemd/system/jenkins_backup_$date.service
echo "Completed backup of jenkins.service."

# Taking backup of jenkins folder
echo "Starting backup of jenkins folder..."
###sudo cp -r /u01/app/jenkins  /stage/asi/Jenkins_backup/jenkins_backup_$date
###sudo tar cvf  /stage/asi/Jenkins_backup/jenkins_backup_$date.tar /u01/app/jenkins
sudo tar cvf  /stage/asi/Jenkins_backup/jenkins_backup_`hostname -s`_$date.tar /u01/app/jenkins
eecho "Completed tar backup of jenkins folder."

# Taking backup of jenkins.war
echo "Starting backup of jenkins.war file..."
sudo cp /usr/share/java/jenkins.war /usr/share/java/jenkins_backup_$date.war
echo "Completed backup of jenkins.war file."

# Taking backup of config.xml
echo "Starting backup of config.xml file..."
sudo cp /u01/app/jenkins/config.xml /u01/app/jenkins/config_$date.xml
echo "Completed backup of config.xml file."

# Remove the current jenkins.war file and download the new one
echo "Removing current jenkins.war and downloading the latest version..."
sudo rm /usr/share/java/jenkins.war
cd /usr/share/java/
sudo wget https://get.jenkins.io/war-stable/2.541.1/jenkins.war # Get the correct Jenkins file 

# Set proper permissions for the new jenkins.war and config.xml
sudo chmod 777 /usr/share/java/jenkins.war
sudo chmod 777 /u01/app/jenkins/config.xml
echo "Permissions updated for jenkins.war and config.xml."

# Start Jenkins service
echo "Starting Jenkins service..."
sudo systemctl start jenkins
echo "Jenkins service started."

# Check Jenkins version
jenkins --version
