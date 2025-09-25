#!/bin/bash

###### set hostname ########
sudo hostnamectl set-hostname nexus-server

###### Install docker and nexus ###########
sudo apt update -y
sudo apt install docker.io -y
sudo chmod 666 /var/run/docker.sock
sudo systemctl restart docker

docker run -d -p 8081:8081 --name nexus sonatype/nexus3