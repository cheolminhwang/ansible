#!/bin/bash

# Check Jenkins version
jenkins --version

 

# Get today's date in mmddyyyy format
date=$(date +"%m%d%Y")

 
# Taking backup of jenkins folder
echo "Starting backup of jenkins folder..."
### cp -r /var/jenkins_home  /stage/asi/Jenkins_backup/jenkins_backup_$date
 tar cvf  ~/jenkins_backup_$date.tar /var/jenkins_home
echo "Completed tar backup of jenkins folder."

# Taking backup of jenkins.war
echo "Starting backup of jenkins.war file..."
 cp /usr/share/jenkins/jenkins.war /usr/share/jenkins/jenkins_backup_$date.war
echo "Completed backup of jenkins.war file."

# Taking backup of config.xml
echo "Starting backup of config.xml file..."
 cp /var/jenkins_home/config.xml /var/jenkins_home/config_$date.xml
echo "Completed backup of config.xml file."

# Remove the current jenkins.war file and download the new one
echo "Removing current jenkins.war and downloading the latest version..."
 rm /usr/share/jenkins/jenkins.war
cd /usr/share/jenkins/
 wget https://get.jenkins.io/war-stable/2.555.3/jenkins.war # Get the correct Jenkins file 

# Set proper permissions for the new jenkins.war and config.xml
 chmod 777 /usr/share/jenkins/jenkins.war
 chmod 777 /var/jenkins_home/config.xml
echo "Permissions updated for jenkins.war and config.xml."


# Check Jenkins version
jenkins --version
