#!/usr/bin/env bash

usage() { echo "$0 usage:" && grep "[[:space:]].)\ #" $0 | sed 's/#//' | sed -E 's/([a-z])\)/-\1/'; exit 0; }
[ $# -eq 0 ] && usage

while getopts ":hs:u:p" arg; do
  case $arg in
    u) # Specify normal username to log in
      USERNAME=${OPTARG}
      ;;
    s) # Specify server hostname
      HOSTNAME=${OPTARG}
      ;;
    p) # Ask for sudo password
      OPTPASS=" --ask-become-pass "
      ;;
    h | *) # Display help.
      usage
      exit 0
      ;;
  esac
done

if [ "0$USERNAME" = "0" -o "0$HOSTNAME" = "0" ]; then
  usage
  exit 1
else
  WORKINGDIR=`echo $(cd $(dirname "$0") && pwd -P)`
  echo "$HOSTNAME" > $WORKINGDIR/inventory
  ansible-playbook -i inventory playbooks/WGserver.yml -u $USERNAME $OPTPASS
fi
