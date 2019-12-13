# IS Read Me


https://tfe-1e61es9p.digitalinnovation.dev:8800/ceph

- you have to reload the shell if you ssh in BEFORE the cloud init finishes.
- `ptfe health-check`


Go to https://tfe-1e61es9p.digitalinnovation.dev:8800/cluster -> click "Ceph Dashboard" to get the u/p

## Questions

- What are the currently supported OS's in the modules?
- Do the primaries NEED public IPs?
- Does the LB DNS need to be public and reachable during installation?
- Do you require a wildcard cert? Can we specify an exact hostname?

## Suggestions

- Allow resource ID's to be passed in, not looking up by names.
- Allow new resources to go into a different RG
- Auto scale VMSS based on some metric to allow spin up/down on workload

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
# source http://github.com/hashicorp/ptfe

openssl pkcs12 -info -in
openssl x509 -in keys/certificate.crt -text -noout





    cert    = "${acme_certificate.tls.certificate_pem}\n${acme_certificate.tls.issuer_pem}"

# Depending on your OpenSSL config, this may prompt you for certificate details
# like Country, Organization, etc. None of the details matter for the purposes of
# authentication and can be set to anything you like.
openssl req -x509 -nodes -sha256 -days 1826 -newkey rsa:2048 -keyout poshacme.key -out poshacme.crt

# change the export password to whatever you want, but remember what it is so you can
# provide it as part of the plugin parameters
openssl pkcs12 -export -in poshacme.crt -inkey poshacme.key -CSP "Microsoft Enhanced RSA and AES Cryptographic Provider" -out poshacme.pfx -passout "pass:poshacme"


```

Health Checks
```
http://tfe-ajpa4cg3-api.digitalinnovation.dev:23010/healthz
```

Preflight
```
kubectl -n kube-system get cm kubeadm-config -oyaml
```e

```sh
kubectl logs -f <pod name>

# most kubectl get commands have a built in --watch
kubectl get pods --watch

<!-- full output -->
journalctl -xu cloud-final
<!-- clean output -->
journalctl -xu cloud-final -o cat -f


```

```sh
terraform destroy \
-target module.tfe_cluster.module.primaries.azurerm_virtual_machine.primary \
-target module.tfe_cluster.module.secondaries.azurerm_virtual_machine_scale_set.secondary
```

### General Debugging

```sh
$ replicated app a78195cbe51d43f74f2d1eb538f63ae3

    "InternalErrorMessageL": "kubectl apply: apply redis-backup: error when creating \"a78195cbe51d43f74f2d1eb538f63ae3\": etcdserver: request timed out",
```

```sh
Failed to join the kubernetes cluster.
2019-11-12T22:22:49.555Z [ERROR] error attempting to join, checking api-server and retrying: error="exit status 1"
2019-11-12T22:22:49.562Z [INFO]  Detected api service address available
2019-11-12T22:22:49.562Z [INFO]  Retrying cluster join
2019-11-12T22:22:49.562Z [DEBUG] executing command: command=/bin/bash arguments="bash setup.sh kubernetes-version=1.15.3 kubeadm-token=einoso.cjc5xs7vuxafp8pr kubeadm-token-ca-hash=sha256:b5a3a898e8fbd8505456ca473f88799859557444391db821aaab966f4aeae800 api-service-address=52.242.231.85:6443 private-address=10.0.0.9 master-pki-bundle-url=http://tfe-ajpa4cg3-api.digitalinnovation.dev:23010/api/v1/pki-download?token=7e1d23zf5htci4e57mxsrov1ccdgic7f"
2019-11-12T22:22:49.562Z [DEBUG] Executing join script: path=setup.sh
Does this machine require a proxy to access the Internet? (y/N) setup.sh: line 299: /dev/tty: No such device or address
⚙  Install kubelet, kubeadm, kubectl and cni binaries
```

```sh
[etcd] Announced new etcd member joining to the existing etcd cluster
[etcd] Wrote Static Pod manifest for a local etcd member to "/etc/kubernetes/manifests/etcd.yaml"
[etcd] Waiting for the new etcd member to join the cluster. This can take up to 40s
[kubelet-check] Initial timeout of 40s passed.
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
error execution phase control-plane-join/update-status: error uploading configuration: unable to create ConfigMap: etcdserver: request timed out
Failed to join the kubernetes cluster.
2019-11-13T02:48:53.019Z [ERROR] error attempting to join, checking api-server and retrying: error="exit status 1"
2019-11-13T02:48:53.130Z [INFO]  Detected api service address available
2019-11-13T02:48:53.130Z [INFO]  Retrying cluster join
2019-11-13T02:48:53.131Z [DEBUG] executing command: command=/bin/bash arguments="bash setup.sh kubernetes-version=1.15.3 kubeadm-token=7iv8nr.e2sx4w7xfgeh75zb kubeadm-token-ca-hash=sha256:3f26e3cbfd8d419ff518982c831655f1291d3c901e62df7c4cbf163e79b07e49 api-service-address=52.242.231.85:6443 private-address=10.0.0.9 master-pki-bundle-url=http://tfe-ajpa4cg3-api.digitalinnovation.dev:23010/api/v1/pki-download?token=7e1d23zf5htci4e57mxsrov1ccdgic7f"
2019-11-13T02:48:53.131Z [DEBUG] Executing join script: path=setup.sh
Does this machine require a proxy to access the Internet? (y/N) setup.sh: line 299: /dev/tty: No such device or address
⚙  Install kubelet, kubeadm, kubectl and cni binaries
✔ Kubernetes components already installed
2.6.2: Pulling from library/registry
Digest: sha256:6cab8c43c5288e6efa87df48019ccf6148def11e6de6fafd8e5270c2b4cdba0e
Status: Image is up to date for registry:2.6.2
⚙  Sync Kubernetes node config
I1113 02:48:54.593647   11574 version.go:248] remote version is much newer: v1.16.2; falling back to: stable-1.15
[certs] Using existing apiserver certificate and key on disk
⚙  Restart kubernetes api server
13dcd10c2c41
```

```sh
$ cat /etc/ptfe/install-ptfe.log | grep "Does this machine require a proxy to access the Internet?"
Does this machine require a proxy to access the Internet? (y/N) setup.sh: line 299: /dev/tty: No such device or address
```


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

### Start up

`ptfe` needs to complete on the primary-0 BEFORE the other primaries start their `ptfe` run. They will wait until primary-0 is up and running.

primary-0 = ~12 mins
primary-1 = ~17 mins
primary-2 = ~21 mins


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