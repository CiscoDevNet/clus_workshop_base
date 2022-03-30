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
    docker run --privileged --name devenv-k3d -d -p 1001:9090 -p 8080:8080 -e "DEVENV_PASSWORD=secret" -e "DEVENV_PASSWORD=secret" -e "DEVENV_APP_URL=http://localhost:8080" containers.cisco.com/tiswanso/devenv-base-k3d:latest
    ```

Once up, new terminals can be instantiated via opening browser tabs to `localhost:1001`

### K3d cluster setup

To create a pair of k3d clusters on the same docker network with metallb configured as the k8s service loadbalancer:

```
cd ~/tools/k3d-env
./k3d_setup.sh
```

The kubeconfigs are in `~/.kube/demo*.kconf**.

#### `k3d_setup.sh` Options

| Env Var      | Default | Description                                                                                       |
|--------------|---------|---------------------------------------------------------------------------------------------------|
| K3D_NUMPEERS |     1 | Number of peer clusters to create                                                                    |
| K3D_NAMEPRFX | demo | Name prefix to use for clusters.  Each cluster instance will have a number after the name prefix.     |
| K3D_API_PORT | 6135 | Starting port number to expose the k8s API server on--subsequent cluster instance will increase by 1. |


### k9s

k9s is usable as a Kubernetes cluster dashboard.  Simply run `k9s` and use `:context` to see the `demo1` and `demo2` contexts.

### SMM Setup

To install SMM on cluster `demo1` and configure cluster `demo2` as a multicluster peer:

```
SMM_REGISTRY_PASSWORD=nIGFzhW3IfYQWW48OTqtS7EDECKn4efk smm activate --host=registry.eticloud.io --prefix=smm --user='sa-dfe96046-00f8-492a-a6ff-3d60136ed17a' -c ~/.kube/demo1.kconf
smm install -c ~/.kube/demo1.kconf -a
smm istio cluster attach --non-interactive -c ~/.kube/demo1.kconf ~/.kube/demo2.kconf
```

#### SMM dashboard access

TBD

