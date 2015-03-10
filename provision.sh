#!/bin/bash
set -e

ANSIBLE_INVENTORY="ansible_inventories/production" 
if [ "${TARGET}" = "localhost" ]; then
  echo "target is localhost"
  ANSIBLE_INVENTORY="ansible_inventories/localhost" 
fi

: ${OPTIONS:=''}

if [ -n "$HOST" ]; then
  OPTIONS+=" -e 'ansible_ssh_host=$HOST'"
fi

if [ -n "$PORT" ]; then
  OPTIONS+=" -e 'ansible_ssh_port=$PORT'"
fi

if [ "$#" -ge 1 ]; then

  if [ "$1" = "remove_pi_password" ]; then
    COMMAND="ansible-playbook ansible_provisioning/remove_default_pi_password.yml \
    -i ${ANSIBLE_INVENTORY} ${OPTIONS}"
    eval $COMMAND

  elif [ "$1" = "setup_ssh_keys" ]; then
    if [ ! -f "authorized_keys" ];then
      echo "no authorized_keys file is found in the current directory!"
      exit 1
    fi
    COMMAND="ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ansible_provisioning/install_public_keys.yml \
    -i ${ANSIBLE_INVENTORY} ${OPTIONS}"
    eval $COMMAND

  elif [ "$1" = "provision" ]; then
    COMMAND="ansible-playbook ansible_provisioning/provisioning.yml \
    -i ${ANSIBLE_INVENTORY} ${OPTIONS}"
    eval $COMMAND

  elif [ "$1" = "nginx" ]; then
    COMMAND="ansible-playbook ansible_provisioning/nginx.yml \
    -i ${ANSIBLE_INVENTORY} ${OPTIONS}"
    eval $COMMAND

  elif [ "$1" = "all" ]; then
    $0 provision
    $0 nginx

  else 
    echo "unknown command: $1"
  fi
else
  echo "please specify a command"
fi

