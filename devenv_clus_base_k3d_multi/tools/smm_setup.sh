#!/bin/bash

SMM_REGISTRY_PASSWORD=nIGFzhW3IfYQWW48OTqtS7EDECKn4efk smm --non-interactive activate -c ~/.kube/demo1.kconf --host=registry.eticloud.io --prefix=smm --user='sa-dfe96046-00f8-492a-a6ff-3d60136ed17a'
smm --non-interactive install -a -c ~/.kube/demo1.kconf

# expose the dashboard
kubectl patch controlplane --type=merge --patch "$(cat /home/developer/tools/smm/enable-dashboard-expose.yaml )" smm --kubeconfig ~/.kube/demo1.kconf
smm --non-interactive operator reconcile -c ~/.kube/demo1.kconf

# attach peer cluster
smm --non-interactive istio cluster attach --non-interactive -c ~/.kube/demo1.kconf ~/.kube/demo2.kconf
