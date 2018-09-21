#!/bin/bash

docker run -it --rm -v $PWD/hosts:/etc/ansible/hosts -v $PWD/id_rsa:/root/.ssh/id_rsa ansible-cli all -m ping
docker run -it --rm -v $PWD/hosts:/etc/ansible/hosts -v $PWD/id_rsa:/root/.ssh/id_rsa -v $PWD/playbooks:/playbooks --entrypoint ansible-playbook ansible-cli /playbooks/pb-inicial.yml
