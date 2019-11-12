# IS Read Me


https://tfe-1e61es9p.digitalinnovation.dev:8800/ceph

- you have to reload the shell if you ssh in BEFORE the cloud init finishes.
- `ptfe health-check`


Go to https://tfe-1e61es9p.digitalinnovation.dev:8800/cluster -> click "Ceph Dashboard" to get the u/p

## Questions

- Do the primaries NEED public IPs?
- Does the LB DNS need to be public and reachable during installation?
- Do you require a wildcard cert? Can we specify an exact hostname?


## Helpful Settings

```sh
# install.sh
cat /var/lib/cloud/scripts/per-once/install-ptfe.sh

# cloud init logs
cat /var/log/cloud-init.log

# settings.json
cat /etc/replicated-ptfe.conf
# replicated.conf
cat /etc/replicated.conf

cat /etc/ptfe/install-ptfe.log

# ptfe cli
curl https://install.terraform.io/installer/ptfe-0.1.zip

openssl pkcs12 -info -in

```

```sh
kubectl logs -f <pod name>

# most kubectl get commands have a built in --watch
kubectl get pods --watch
```

journalctl -xu cloud-final


```sh
terraform destroy \
-target module.tfe_cluster.module.primaries.azurerm_virtual_machine.primary \
-target module.tfe_cluster.module.secondaries.azurerm_virtual_machine_scale_set.secondary
```

### General Debugging

```sh
To start administering your cluster from this node, you need to run the following as a regular user:

	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

```sh
# replicated app xxx
"InternalErrorMessageL": "Unmet start requirement: list nodes: Get https://10.96.0.1:443/api/v1/nodes: unexpected EOF",
```

```sh
$ kubectl get nodes
NAME                            STATUS   ROLES    AGE     VERSION
tfe-ajpa4cg3-primary-0          Ready    master   19m     v1.15.3
tfe-ajpa4cg3-primary-1          Ready    <none>   4m52s   v1.15.3
tfe-ajpa4cg3-primary-2          Ready    master   99s     v1.15.3
tfe-ajpa4cg3-secondary-000000   Ready    <none>   7m25s   v1.15.3
tfe-ajpa4cg3-secondary-000001   Ready    <none>   6m57s   v1.15.3
```



### Public IP

Needs LB public access???

```
● kubelet.service - kubelet: The Kubernetes Node Agent
   Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
  Drop-In: /etc/systemd/system/kubelet.service.d
           └─10-kubeadm.conf
   Active: active (running) since Mon 2019-11-11 22:50:44 UTC; 4min 41s ago
     Docs: https://kubernetes.io/docs/home/
 Main PID: 9837 (kubelet)
    Tasks: 17
   Memory: 37.5M
      CPU: 7.239s
   CGroup: /system.slice/kubelet.service
           └─9837 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --cgroup-driver=cgroupfs --network-plugin=cni --pod-infra-container-image=k8s.gcr.io/pause:3.1

Nov 11 22:55:25 tfe-ajpa4cg3-primary-0 kubelet[9837]: E1111 22:55:25.084527    9837 kubelet.go:2248] node "tfe-ajpa4cg3-primary-0" not found
Nov 11 22:55:25 tfe-ajpa4cg3-primary-0 kubelet[9837]: E1111 22:55:25.164014    9837 reflector.go:125] k8s.io/client-go/informers/factory.go:133: Failed to list *v1beta1.RuntimeClass: Get https://tfe-ajpa4cg3-api.digitalinnovation.dev:6443/apis/node.k8s.io/v1beta1/runtimeclasses?limit=500&resourceVersion=0: dial tcp: lookup tfe-ajpa4cg3-
Nov 11 22:55:25 tfe-ajpa4cg3-primary-0 kubelet[9837]: E1111 22:55:25.184795    9837 kubelet.go:2248] node "tfe-ajpa4cg3-primary-0" not found
Nov 11 22:55:25 tfe-ajpa4cg3-primary-0 kubelet[9837]: E1111 22:55:25.285003    9837 kubelet.go:2248] node "tfe-ajpa4cg3-primary-0" not found
Nov 11 22:55:25 tfe-ajpa4cg3-primary-0 kubelet[9837]: E1111 22:55:25.364017    9837 reflector.go:125] k8s.io/client-go/informers/factory.go:133: Failed to list *v1beta1.CSIDriver: Get https://tfe-ajpa4cg3-api.digitalinnovation.dev:6443/apis/storage.k8s.io/v1beta1/csidrivers?limit=500&resourceVersion=0: dial tcp: lookup tfe-ajpa4cg3-api.
Nov 11 22:55:25 tfe-ajpa4cg3-primary-0 kubelet[9837]: E1111 22:55:25.385178    9837 kubelet.go:2248] node "tfe-ajpa4cg3-primary-0" not found
Nov 11 22:55:25 tfe-ajpa4cg3-primary-0 kubelet[9837]: E1111 22:55:25.485390    9837 kubelet.go:2248] node "tfe-ajpa4cg3-primary-0" not found
Nov 11 22:55:25 tfe-ajpa4cg3-primary-0 kubelet[9837]: E1111 22:55:25.564742    9837 reflector.go:125] k8s.io/kubernetes/pkg/kubelet/kubelet.go:453: Failed to list *v1.Node: Get https://tfe-ajpa4cg3-api.digitalinnovation.dev:6443/api/v1/nodes?fieldSelector=metadata.name%3Dtfe-ajpa4cg3-primary-0&limit=500&resourceVersion=0: dial tcp: look
Nov 11 22:55:25 tfe-ajpa4cg3-primary-0 kubelet[9837]: E1111 22:55:25.585621    9837 kubelet.go:2248] node "tfe-ajpa4cg3-primary-0" not found
Nov 11 22:55:25 tfe-ajpa4cg3-primary-0 kubelet[9837]: E1111 22:55:25.685847    9837 kubelet.go:2248] node "tfe-ajpa4cg3-primary-0" not found
```

### Patience

If you are seeing this but `replicated apps` isnt showing TFE running, just wait a bit.

```sh
$ tail -f /etc/ptfe/install-ptfe.log

    http://10.0.0.11:8800


2019-11-12T01:08:51.206Z [INFO]  Configured system
2019-11-12T01:08:51.206Z [TRACE] setup/setup-script-finished
2019-11-12T01:08:51.206Z [DEBUG] Adding bootstrap token to install
0jn7kw.q0y8duuyps05glim
2019-11-12T01:08:51.350Z [INFO]  Added bootstrap token
2019-11-12T01:08:51.386Z [INFO]  Added setup assistant service
```