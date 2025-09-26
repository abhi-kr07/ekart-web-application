#!/bin/bash

######### set hostname #######
sudo hostnamectl set-hostname sonarqube-server

####### Install docker and sonarqube ############
sudo apt update -y
sudo apt install docker.io -y
sudo chmod 666 /var/run/docker.sock
sudo systemctl restart docker

docker run -d -p 9000:9000 --name sonarqube sonarqube:lts-community