#!/bin/bash

dockerd-entrypoint.sh &> /var/log/dockerd-entrypoint.log &

sleep 20

if [[ "${DEVENV_AUTOSTART}" == "true" ]]; then
    /home/developer/tools/full_setup.sh
fi

