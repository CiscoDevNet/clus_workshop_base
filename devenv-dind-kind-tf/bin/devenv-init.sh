#!/bin/bash

reload-devenv-proxy.sh

dockerd-entrypoint.sh &> /var/log/dockerd-entrypoint.log &

sleep 10

touch /var/log/kind.log

kind create cluster &> /var/log/kind.log &
