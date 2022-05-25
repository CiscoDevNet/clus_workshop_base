#!/usr/bin/env bash

CLUSTER_TYPE=${CLUSTER_TYPE:kind}
HOSTIP_MATCH=${HOSTIP_MATCH:-10.87}
#K8S_API_ADDR=$(ip a | grep inet.${HOSTIP_MATCH} |  awk '{ print $2 }' | cut -d '/' -f 1)
#K3D_API_ADDR=${K3D_API_ADDR:-127.0.0.1}
K3D_NAMEPRFX=${K3D_NAMEPRF:-demo}
GLOBAL_METALLB_PRFX=${GLOBAL_METALLB_PRFX:-250}
K3D_API_PORT=${K3D_API_PORT:-6135}
K3D_NUMPEERS=${K3D_NUMPEERS:-1}
# https://github.com/kubernetes-sigs/kind/releases/tag/v0.11.1
KIND_IMAGE=${KIND_IMAGE:-kindest/node:v1.19.11@sha256:07db187ae84b4b7de440a73886f008cf903fcf5764ba8106a9fd5243d6f32729}
#KIND_IMAGE=${KIND_IMAGE:-kindest/node:v1.21.1@sha256:69860bda5563ac81e3c0057d654b5253219618a22ec3a346306239bba8cfa1a6}

if [[ -z ${K8S_API_ADDR} ]]; then
    K8S_API_ADDR=$(hostname -i)
    #K3D_API_SAN=${K3D_API_ADDR}
fi

# create_cluster
# - creates either a kind or a k3d cluster depending on the $CLUSTER_TYPE global variable
#
# NOTE: Since SMM multicluster peers need to be able to reach each other's api-server we need to use
# a reachable api-server address in the cluster creation so the kubeconfig server field is usable from
# within the clusters.
#
function create_cluster {
    local name=$1; shift
    if [[ $# > 1 ]]; then
        local apiaddr=$1; shift
        local portoffset=$1; shift
    fi

    if [[ "$CLUSTER_TYPE" == "k3d" ]]; then
        apiport=$((${K3D_API_PORT} + ${portoffset}))
        k3d cluster create ${name} --no-lb --api-port ${apiaddr}:${apiport} --network k3d-${K3D_NAMEPRFX} --k3s-arg '--disable=servicelb' --k3s-arg '--disable=traefik' ${K3D_API_SAN:- --k3s-arg "--tls-san=${K3D_API_SAN}"} --k3s-arg '--disable-network-policy' --k3s-arg '--flannel-backend=none' --k3s-arg 'cloud-provider=external' --k3s-arg '--disable-cloud-controller' --volume "$(pwd)/calico.yaml:/var/lib/rancher/k3s/server/manifests/calico.yaml" --volume $(pwd)/resolv.conf:/etc/resolv.conf
        k3d kubeconfig get ${name} > ~/.kube/${name}.kconf
    else
        cat <<EOF > kind_config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  # WARNING: It is _strongly_ recommended that you keep this the default
  # (127.0.0.1) for security reasons. However it is possible to change this.
  apiServerAddress: "${apiaddr}"
  # By default the API server listens on a random open port.
  # You may choose a specific port but probably don't need to in most cases.
  # Using a random port makes it easier to spin up multiple clusters.
  # apiServerPort: 6443
nodes:
- role: control-plane
  image: ${KIND_IMAGE}
EOF

        kind create cluster --name ${name} --config kind_config.yaml
        kind get kubeconfig --name ${name} > ~/.kube/${name}.kconf
    fi

}

# Bringup "primary" k3d instance (k3d creates docker network k3d-${K3D_NAMEPRFX}1)
#k3d cluster create ${K3D_NAMEPRFX}1 --no-lb --api-port ${K3D_API_ADDR}:${K3D_API_PORT} --k3s-arg '--disable=servicelb' --k3s-arg '--disable=traefik' ${K3D_API_SAN:- --k3s-arg "--tls-san=${K3D_API_SAN}"} --k3s-arg '--disable-network-policy' --k3s-arg '--flannel-backend=none' --k3s-arg 'cloud-provider=external' --k3s-arg '--disable-cloud-controller' --volume "$(pwd)/calico.yaml:/var/lib/rancher/k3s/server/manifests/calico.yaml" --volume $(pwd)/resolv.conf:/etc/resolv.conf
 
#k3d kubeconfig get ${K3D_NAMEPRFX}1 > ~/.kube/${K3D_NAMEPRFX}1.kconf

create_cluster ${K3D_NAMEPRFX}1 ${K8S_API_ADDR} 0

for (( cur_cluster=0; cur_cluster < $K3D_NUMPEERS; cur_cluster++))
do

    # peers offset starts at 2
    cluster_name=${K3D_NAMEPRFX}$((${cur_cluster} + 2))

    create_cluster $cluster_name ${K8S_API_ADDR} $((${cur_cluster} + 1))

    # -- OLD CODE --
    # Bringup "peer" k3d instance (use network k3d-${K3D_NAMEPRFX}1 created by k3d in prior command)
    #k3d cluster create ${cluster_name} --no-lb --api-port ${K3D_API_ADDR}:${K3D_API_PORT} --network k3d-${K3D_NAMEPRFX}1 --k3s-arg '--disable=servicelb' --k3s-arg '--disable=traefik' ${K3D_API_SAN:- --k3s-arg "--tls-san=${K3D_API_SAN}"} --k3s-arg '--disable-network-policy' --k3s-arg '--flannel-backend=none' --k3s-arg 'cloud-provider=external' --k3s-arg '--disable-cloud-controller' --volume "$(pwd)/calico.yaml:/var/lib/rancher/k3s/server/manifests/calico.yaml" --volume $(pwd)/resolv.conf:/etc/resolv.conf 
    #k3d kubeconfig get ${cluster_name} > ~/.kube/${cluster_name}.kconf
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

