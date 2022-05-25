#!/bin/bash

/home/developer/tools/cluster_env/cluster_setup.sh

if [[ "${DEVENV_ONLYCLUSTERS}" == "true" ]]; then
    exit
fi

sleep 30

/home/developer/tools/smm_setup.sh

ingressip=$(kubectl get svc smm-ingressgateway-external -n smm-system --kubeconfig ~/.kube/demo1.kconf  -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
caddy reverse-proxy --from :8080 --to ${ingressip}:80 &
