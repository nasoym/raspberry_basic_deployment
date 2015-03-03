#!/bin/bash
set -e

if [ "$#" -ge 1 ]; then
  export TARGET=production
  export HOST=$1
  if [ "$#" -ge 2 ]; then
    export PORT=$2
  fi
  OPTIONS="-vvv"
  if [ -f "authorized_keys" ];then
    ./provision.sh setup_ssh_keys
  fi
  ./provision.sh provision
  ./provision.sh nginx
  ./deploy.sh webclient
else
  echo "please specify the ip address or hostname of the deployment target"
fi
