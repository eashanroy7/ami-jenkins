#!/bin/bash

# Set debconf to run in non-interactive mode
export DEBIAN_FRONTEND=noninteractive

# This script installs, configures and starts Jenkins on the AMI

##########################################################################
## Installing Jenkins and other dependencies

# Update package information
sudo apt-get update -y

# Install Java (Required by Jenkins) and Maven
sudo apt-get install -y openjdk-11-jdk maven

# Download the Jenkins repository key and saves it to /usr/share/keyrings/jenkins-keyring.asc,
# which is used to authenticate packages
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add the Jenkins repository to the packages sources list, specifying that packages from
# this repository should be verified using the key saved in /usr/share/keyrings/jenkins-keyring.asc.
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update the package lists to include newly available packages from the added Jenkins repository.
sudo apt-get update

# Install the Jenkins package from the newly added repository
sudo apt-get install jenkins -y

sleep 3

# Check the status of Jenkins service
sudo systemctl --full status jenkins

# Check Jenkins version
echo "Jenkins $(jenkins --version)"

##########################################################################
## Installing Plugins for Jenkins

# Install Jenkins plugin manager tool to be able to install the plugins on EC2 instance
wget --quiet \
  https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.13/jenkins-plugin-manager-2.12.13.jar

# Install plugins with jenkins-plugin-manager tool:
sudo java -jar ./jenkins-plugin-manager-2.12.13.jar --war /usr/share/java/jenkins.war \
  --plugin-download-directory /var/lib/jenkins/plugins --plugin-file /home/ubuntu/plugins.txt

# Update users and group permissions to `jenkins` for all installed plugins:
cd /var/lib/jenkins/plugins/ || exit
sudo chown jenkins:jenkins ./*

# Configure JAVA_OPTS to disable setup wizard
sudo mkdir -p /etc/systemd/system/jenkins.service.d/
{
  echo "[Service]"
  echo "Environment=\"JAVA_OPTS=-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false\""
} | sudo tee /etc/systemd/system/jenkins.service.d/override.conf

# Restart jenkins service
sudo systemctl daemon-reload
sudo systemctl stop jenkins
sudo systemctl start jenkins