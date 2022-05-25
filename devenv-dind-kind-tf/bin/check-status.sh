#!/bin/bash

# Usage:
#   check-status.sh docker
#   check-status.sh k8s

function check_status_docker() {
  OUTPUT=$(docker info 2>&1)
  EXIT_CODE=$?
  if [ $EXIT_CODE -ne 0 ]; then
    printf "\n[%s] Docker is not ready yet.\n" "$(date)"
    cat /var/log/dockerd-entrypoint.log
    return 1
  else
    printf "\n[%s] Docker is ready to go.\n" "$(date)"
#    echo "${OUTPUT}"
    return 0
  fi
}

function check_status_k8s() {
  OUTPUT=$(kubectl cluster-info 2>&1)
  EXIT_CODE=$?
  if [ $EXIT_CODE -ne 0 ]; then
    printf "\n[%s] K8s cluster is not ready yet.\n" "$(date)"
    cat /var/log/kind.log
    return 1
  else
    printf "\n[%s] K8s cluster is ready to go.\n" "$(date)"
#    echo "${OUTPUT}"
    return 0
  fi
}

function check_status() {
  # Repeatedly (every RETRY_WAIT_TIME) check status until success or until timeout (RETRY_MAX_TIME).
  RETRY_MAX_TIME=90
  RETRY_WAIT_TIME=5
  until [ "${RETRY_WAIT_TIME}" -eq ${RETRY_MAX_TIME} ] || $1; do
    sleep $(( RETRY_WAIT_TIME++ ))
  done
  [ "${RETRY_WAIT_TIME}" -lt 1 ]
}

echo "[$(date)] Checking status for ${1}..."
if [[ "$1" == "docker" ]]; then
  check_status check_status_docker
elif [[ "$1" == "k8s" ]]; then
  check_status check_status_k8s
else
  echo "Invalid arg '${1}'. Valid args: docker, k8s."
  exit 1
fi
