#!/bin/bash

set -e
set -u

TARGET=$1
REMOTE_USER=$2
PROJECT_URL=$3
PROJECT_NAME=$4
GIT_VERSION=$5

ansible-playbook -c paramiko -u $REMOTE_USER -i "$TARGET," \
   --extra-vars "PROJECT_URL=$PROJECT_URL PROJECT_NAME=$PROJECT_NAME  REMOTE_USER=$REMOTE_USER GIT_VERSION=$GIT_VERSION" \
   provisioning/site.yml -v
