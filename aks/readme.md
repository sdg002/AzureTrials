[[_TOC_]]

# My lessons on Azure AKS


# Getting AKS credentials

## AZ CLI
```
az aks Get-Credentials --resource-group $global:ResourceGroup --name "AKS-DEV-PORTAL"
```
This will download a credential file to the folder `%USERPROFILE%\.kube\config`


## Sample .kube/config file

```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0****wS0EyCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://aks-dev-portal-dns-xs6owjf7.hcp.uksouth.azmk8s.io:443
  name: AKS-DEV-PORTAL
contexts:
- context:
    cluster: AKS-DEV-PORTAL
    user: clusterUser_RG-AKS-DEMO-001_AKS-DEV-PORTAL
  name: AKS-DEV-PORTAL
current-context: AKS-DEV-PORTAL
kind: Config
preferences: {}
users:
- name: clusterUser_RG-AKS-DEMO-001_AKS-DEV-PORTAL
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSU******ORCBDRVJUSUZJQ0FURS0tLS0tCg==
    client-key-data: LS0tLS1CRUdJTiB**********0tLS0K
    token: lu2s*******r

```

---

# KubeLogin

You will need kubelogin for authenticating KubeCtl with AKS

## How to install ?

When working with Azure, there is a specific version that is needed. The following recommended by MS:

```
az aks install-cli
```

## Where does KubeLogin get installed ?

```
$env:USERPROFILE\.azure-kubelogin
```


## Setting the path to KubeConfig

```
$ENV:KUBECONFIG="$env:USERPROFILE\.kube\config"
```

## Convertingthe Kube config

```
kubelogin convert-kubeconfig
```

## Getting the namespace

This will open up a browser for authentication:

```
kubectl get namespaces
```

## MS Documentation

https://learn.microsoft.com/en-us/azure/aks/kubelogin-authentication



# KubeCtl

This is the CLI for dealing with Kubernetes

## Where to download ?
https://kubernetes.io/releases/download/#binaries

Note  - this does not have an EXE extension. This is not zipped up. The file comes down read to be executed

## Version check

```
kubectl version

Client Version: v1.28.2
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: v1.29.7
```

## cluster-info

```
kubectl cluster-info
```


Expected output
```
Kubernetes control plane is running at https://aks-dev-portal-dns-xs6owjf7.hcp.uksouth.azmk8s.io:443
CoreDNS is running at https://aks-dev-portal-dns-xs6owjf7.hcp.uksouth.azmk8s.io:443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://aks-dev-portal-dns-xs6owjf7.hcp.uksouth.azmk8s.io:443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

---

## cluster-info with dump option

```
kubectl cluster-info dump --output-directory .\kube-dump
```

Expected output
```
root
    -default
    -kube-system
```


## get nodes

```
kubectl get nodes
```
Expected output:
```
NAME                                  STATUS   ROLES    AGE   VERSION
aks-mysystempol-70397340-vmss000000   Ready    <none>   38m   v1.29.7
```

## kubectl config view

```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://aks-dev-portal-dns-xs6owjf7.hcp.uksouth.azmk8s.io:443
  name: AKS-DEV-PORTAL
contexts:
- context:
    cluster: AKS-DEV-PORTAL
    user: clusterUser_RG-AKS-DEMO-001_AKS-DEV-PORTAL
  name: AKS-DEV-PORTAL
current-context: AKS-DEV-PORTAL
kind: Config
preferences: {}
users:
- name: clusterUser_RG-AKS-DEMO-001_AKS-DEV-PORTAL
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED
    token: REDACTED
```

## kubectl config  current-context

```
AKS-DEV-PORTAL
```
