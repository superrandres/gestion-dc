#!/bin/bash

docker run -it --rm -v $PWD/hosts:/etc/ansible/hosts -v $PWD/id_rsa:/root/.ssh/id_rsa ansible-cli all -m ping
