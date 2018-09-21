#!/bin/bash

source ./box.sh

box "Remove existing containers" "blue" "red"
docker rm -f centos1 centos2 ubuntu1
box "Remove existing ssh key file" "blue" "red"
rm ./id_rsa
echo "" > /home/ronald/.ssh/known_hosts
box "Create new container : centos" "green" "blue"
docker run --name centos1 --hostname centos1 -d -v /etc/localtime:/etc/localtime:ro centos-sshd
box "Create new container : centos 2" "green" "blue"
docker run --name centos2 --hostname centos2 -d -v /etc/localtime:/etc/localtime:ro centos-sshd
box "Create new container : Centos" "green" "blue"
docker run --name ubuntu1 --hostname ubuntu1 -d -v /etc/localtime:/etc/localtime:ro ubuntu-sshd
box "Create new RSA ssh key" "green" "blue"
ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)-$(date)" -f ./id_rsa -q -N ""
box "Copy ssh key on each container -- password is 'toor'" "yellow" "purple"
docker ps --format "{{.Names}}" | grep "ubuntu\|centos" | xargs -i docker inspect -f "{{ .NetworkSettings.IPAddress }}" {} | xargs -i ssh-copy-id -i ./id_rsa root@{}
box "Create Ansible hosts file" "green" "blue"
echo [centos1] > hosts
docker ps --format "{{.Names}}" | grep "centos1" | xargs -i docker inspect -f "{{ .NetworkSettings.IPAddress }}" {} | xargs -i echo {} ansible_user=root >> hosts
echo [centos2] >> hosts
docker ps --format "{{.Names}}" | grep "centos2" | xargs -i docker inspect -f "{{ .NetworkSettings.IPAddress }}" {} | xargs -i echo {} ansible_user=root >> hosts
echo [ubuntu1] >> hosts
docker ps --format "{{.Names}}" | grep "ubuntu1" | xargs -i docker inspect -f "{{ .NetworkSettings.IPAddress }}" {} | xargs -i echo {} ansible_user=root >> hosts
 