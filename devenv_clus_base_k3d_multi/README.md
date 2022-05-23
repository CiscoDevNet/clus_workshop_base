# K3D Multicluster Setup

This dev/demo environment is for building out multicluster scenarios.  It sets up k3d clusters (k3d is to k3s as KinD is to K8s).

## Usage

### Container bringup

Options:

1.  If cloned this repo:

    ```
    make run
    ```

2.  Otherwise use docker directly:

    ```
    docker run --privileged --name devenv-k3d -d --rm -p 1001:9090 -p 30880:8080 -e "DEVENV_PASSWORD=secret" -e "DEVENV_PASSWORD=secret" -e "DEVENV_APP_URL=http://localhost:8080" containers.cisco.com/tiswanso/devenv-base-k3d:latest
    ```

Once up, new terminals can be instantiated via opening browser tabs to `localhost:1001/?arg=secret`

### Cluster setup

To create a pair of k3d clusters on the same docker network with metallb configured as the k8s service loadbalancer:

```
cd /home/developer/tools/cluster-env
 ./cluster_setup.sh
```

The kubeconfigs are in `~/.kube/demo*.kconf**.

![cluster_setup](images/cluster_setup.png**

**NOTE:** The default cluster type is `kind` but `k3d` clusters will be created via:
```
CLUSTER_TYPE=k3d ./cluster_setup.sh
```

#### `cluster_setup.sh` Options

| Env Var      | Default | Description                                                                                           |
|--------------+---------+-------------------------------------------------------------------------------------------------------|
| K3D_NUMPEERS |       1 | Number of peer clusters to create                                                                     |
| K3D_NAMEPRFX |    demo | Name prefix to use for clusters.  Each cluster instance will have a number after the name prefix.     |
| K3D_API_PORT |    6135 | Starting port number to expose the k8s API server on--subsequent cluster instance will increase by 1. |
| CLUSTER_TYPE | kind    | Set to `k3d` to use k3d clusters                                                                       |


### k9s

k9s is usable as a Kubernetes cluster dashboard.  Simply run `k9s` and use `:context` to see the `demo1` and `demo2` contexts.

![k9s start](images/k9s_start.png)

![k9s contexts](images/k9s_contexts.png)

![k9s demo1 pods](images/k9s_demo1_pods.png)


### SMM Setup

To install SMM on cluster `demo1` and configure cluster `demo2` as a multicluster peer:

```
SMM_REGISTRY_PASSWORD=nIGFzhW3IfYQWW48OTqtS7EDECKn4efk smm --non-interactive activate -c ~/.kube/demo1.kconf --host=registry.eticloud.io --prefix=smm --user='sa-dfe96046-00f8-492a-a6ff-3d60136ed17a'
smm --non-interactive install -a -c ~/.kube/demo1.kconf

# expose the dashboard
kubectl patch controlplane --type=merge --patch "$(cat /home/developer/tools/smm/enable-dashboard-expose.yaml )" smm --kubeconfig ~/.kube/demo1.kconf
smm --non-interactive operator reconcile -c ~/.kube/demo1.kconf

# attach peer cluster
smm --non-interactive istio cluster attach --non-interactive -c ~/.kube/demo1.kconf ~/.kube/demo2.kconf
```

![smm init progress](images/smm_init.png)

![k9s smm init](images/k9s_demo1_smm_init.png)

![smm init done](images/smm_init_done.png)

![smm cluster attach](images/smm_cluster_attach.png)

![k9s smm cluster attach](images/k9s_smm_cluster_attach.png)

#### SMM dashboard access

In a new window (browser terminal http://localhost:1001/?arg=secret)

1. Proxy the exposed host port to the dashboard listening port.  The host running the `docker run` command has its port
   30880 mapped to port 8080 inside the container with k3d running.  We'll use `caddy` to proxy that to the port
   `smm dashboard` is using.
   
   ```
   ingressip=$(kubectl get svc smm-ingressgateway-external -n smm-system --kubeconfig ~/.kube/demo1.kconf  -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
   caddy reverse-proxy --from :8080 --to ${ingressip}:80 &
   ```

2. Access the dashboard via browser on your docker host via `http://localhost:30880`

   ![SMM dashboard](images/k9s_smm_dash_login.png)

NOTE: you shouldn't need to use `smm login` to obtain the token to login to the dashboard.
