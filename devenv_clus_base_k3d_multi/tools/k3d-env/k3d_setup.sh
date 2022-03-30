#!/usr/bin/env bash

HOSTIP_MATCH=${HOSTIP_MATCH:-10.87}
K3D_API_ADDR=$(ip a | grep inet.${HOSTIP_MATCH} |  awk '{ print $2 }' | cut -d '/' -f 1)
#K3D_API_ADDR=${K3D_API_ADDR:-127.0.0.1}
K3D_NAMEPRFX=${K3D_NAMEPRF:-demo}
GLOBAL_METALLB_PRFX=${GLOBAL_METALLB_PRFX:-250}
K3D_API_PORT=${K3D_API_PORT:-6135}
K3D_NUMPEERS=${K3D_NUMPEERS:-1}

if [[ -z ${K3D_API_ADDR} ]]; then
    K3D_API_ADDR=$(hostname -i)
    #K3D_API_SAN=${K3D_API_ADDR}
fi

# Bringup "primary" k3d instance (k3d creates docker network k3d-${K3D_NAMEPRFX}1)
k3d cluster create ${K3D_NAMEPRFX}1 --no-lb --api-port ${K3D_API_ADDR}:${K3D_API_PORT} --k3s-arg '--disable=servicelb' --k3s-arg '--disable=traefik' ${K3D_API_SAN:- --k3s-arg "--tls-san=${K3D_API_SAN}"} --k3s-arg '--disable-network-policy' --k3s-arg '--flannel-backend=none' --k3s-arg 'cloud-provider=external' --k3s-arg '--disable-cloud-controller' --volume "$(pwd)/calico.yaml:/var/lib/rancher/k3s/server/manifests/calico.yaml" --volume $(pwd)/resolv.conf:/etc/resolv.conf
 
k3d kubeconfig get ${K3D_NAMEPRFX}1 > ~/.kube/${K3D_NAMEPRFX}1.kconf

for (( cur_cluster=0; cur_cluster < $K3D_NUMPEERS; cur_cluster++))
do

    K3D_API_PORT=$((${K3D_API_PORT} + 1))
    # peers offset starts at 2
    cluster_name=${K3D_NAMEPRFX}$((${cur_cluster} + 2))

    # Bringup "peer" k3d instance (use network k3d-${K3D_NAMEPRFX}1 created by k3d in prior command)
    k3d cluster create ${cluster_name} --no-lb --api-port ${K3D_API_ADDR}:${K3D_API_PORT} --network k3d-${K3D_NAMEPRFX}1 --k3s-arg '--disable=servicelb' --k3s-arg '--disable=traefik' ${K3D_API_SAN:- --k3s-arg "--tls-san=${K3D_API_SAN}"} --k3s-arg '--disable-network-policy' --k3s-arg '--flannel-backend=none' --k3s-arg 'cloud-provider=external' --k3s-arg '--disable-cloud-controller' --volume "$(pwd)/calico.yaml:/var/lib/rancher/k3s/server/manifests/calico.yaml" --volume $(pwd)/resolv.conf:/etc/resolv.conf 
    k3d kubeconfig get ${cluster_name} > ~/.kube/${cluster_name}.kconf
done

# Find the node's first 2 octets for use to create metallb IP ranges (assumes k3d docker networks are using /16 cidr):
kconf=~/.kube/${K3D_NAMEPRFX}1.kconf
nodeAddrPrfx=$(kubectl get nodes --kubeconfig ${kconf} -o jsonpath="{.items[0].status.addresses[?(@.type=='InternalIP')].address}" | cut -d '.' -f 1,2)


# Install metallb in all the clusters (use the later 3 octets of the docker bridge prefix)
for (( cur_cluster=0; cur_cluster < $K3D_NUMPEERS + 1; cur_cluster++))
do
    cluster_name=${K3D_NAMEPRFX}$((${cur_cluster} + 1))

    kconf=~/.kube/${cluster_name}.kconf
 
    kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml --kubeconfig ${kconf}

    cat <<EOF | kubectl apply --kubeconfig ${kconf} -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - ${nodeAddrPrfx}.${GLOBAL_METALLB_PRFX}.1-${nodeAddrPrfx}.${GLOBAL_METALLB_PRFX}.250
EOF
    GLOBAL_METALLB_PRFX=$((${GLOBAL_METALLB_PRFX} + 1))
done

