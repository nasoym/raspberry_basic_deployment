#!/bin/bash
set -e

ANSIBLE_INVENTORY="ansible_inventories/localhost" 
if [ "${TARGET}" = "production" ]; then
  echo "target is production"
  ANSIBLE_INVENTORY="ansible_inventories/production" 
fi

: ${OPTIONS:=''}

if [ -n "$HOST" ]; then
  OPTIONS+=" -e 'ansible_ssh_host=$HOST'"
fi

if [ -n "$PORT" ]; then
  OPTIONS+=" -e 'ansible_ssh_port=$PORT'"
fi

if [ "$#" -ge 1 ]; then

  if [ "$1" = "webclient" ]; then
    COMMAND="ansible-playbook ansible_deployment/webclient.yml \
    -i ${ANSIBLE_INVENTORY} ${OPTIONS}"
    eval $COMMAND

  elif [ "$1" = "all" ]; then
    $0 webclient

  else 
    echo "unknown command: $1"
  fi
else
  echo "please specify a command"
fi

