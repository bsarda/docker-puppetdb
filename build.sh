#!/bin/sh
docker ps -a | grep bsarda/puppetdb | awk '{print $1}' | xargs -n1 docker rm -f
docker rmi bsarda/puppetdb
docker build -t bsarda/puppetdb .
