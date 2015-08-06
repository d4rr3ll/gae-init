#!/bin/bash

set -e               # exit on error

BASEDIR=$(dirname "$0")
cd "${BASEDIR}" # connect to root

docker build -t gae-init docker/

if [ "$(uname -s)" == "Linux" ]; then
  USER_NAME=${SUDO_USER:=$USER}
  USER_ID=$(id -u "${USER_NAME}")
  GROUP_ID=$(id -g "${USER_NAME}")
else # boot2docker uid and gid
  USER_NAME=$USER
  USER_ID=1000
  GROUP_ID=50
fi

#
# sudo setup from here :
# http://stackoverflow.com/questions/25845538/using-sudo-inside-a-docker-container
#

docker build -t "gae-init-${USER_NAME}" - <<UserSpecificDocker
FROM gae-init
RUN groupadd --non-unique -g ${GROUP_ID} ${USER_NAME}
RUN useradd -g ${GROUP_ID} -u ${USER_ID} -k /root -m ${USER_NAME}
RUN echo "${USER_NAME}:password" | chpasswd && adduser ${USER_NAME} sudo
ENV HOME /home/${USER_NAME}
UserSpecificDocker

# sudo pip install -r requirements.txt
# npm install
# bower install
# sh run.sh &
# gulp

# Setup remote notifications
# https://github.com/fgrehm/notify-send-http
#
# Client first...
# Grab Docker bridge IP
DOCKER_BRIDGE_IP=$(/sbin/ifconfig docker0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

# Run docker
docker run --rm=true -t -i \
  -v "${PWD}:/home/${USER_NAME}/gae-init" \
  -w "/home/${USER_NAME}/gae-init" \
  -u "${USER_NAME}" \
  -p 35729:35729 \
  -p 8080:8080 \
  -p 8081:8081 \
  "gae-init-${USER_NAME}" \
  gulp -o 0.0.0.0 -a"--admin_host=0.0.0.0 --log_level=debug --dev_appserver_log_level=debug --skip_sdk_update_check=1"

# @TODO: Set all GAE paths to something local so data,blobs,images etc is maintained across runs


