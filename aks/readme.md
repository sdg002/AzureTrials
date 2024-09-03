[[_TOC_]]

# My lessons on Azure AKS


# 101-deploy
In this section we deploy an AKS using the simplest possible Azure CLI commands and do some experiments using `Kubectl` and `KubeLogin`.


# 200-sample-worker

## How to create a namespace ?

Look at the YAML here. This just has the name spaces
https://github.com/Azure/kubernetes-hackfest/blob/master/labs/create-aks-cluster/README.md

```powershell
kubectl apply --filename $PSScriptRoot/namespaces.yaml
```

and also read this

https://cloud.google.com/blog/products/containers-kubernetes/kubernetes-best-practices-organizing-with-namespaces



## How to delete a namespace ?

```
kubectl delete namespaces uat
```

## How to get all namespaces ?

```
kubectl get namespace
```

Example output:
```
NAME                   STATUS   AGE
thisnamespace            Active   353d
thatnamespace            Active   586d
```

## Good article on understanding deployment YAML structure

https://www.mirantis.com/blog/introduction-to-yaml-creating-a-kubernetes-deployment#basics


## Creating Pods in the namespace

https://cloud.google.com/blog/products/containers-kubernetes/kubernetes-best-practices-organizing-with-namespaces

```powershell
kubectl apply --filename $PSScriptRoot/pod.yaml --namespace=demoapp
```

```
kubectl get pods
```

## How to know the pods in a namespace 

```
kubectl get pods --namespace ingress-nginx
```

Example output:
```
NAME                                              READY   STATUS                   RESTARTS        AGE
trading-lse-receiver-123a7f754d-v8tzl             1/1     Running                  0               38d
trading-nys-receiver-1234dd74d-8ng9k              1/1     Running                  0               16h
```

https://spacelift.io/blog/kubernetes-namespaces


## See details of a namespace

```
kubectl describe namespace mynamespace
```

Sample output:
```
Name:         mynamespace
Labels:       kubernetes.io/metadata.name=mynamespace
              name=mynamespace
Annotations:  <none>
Status:       Active
```

## Show resource usage of pods in a namespace

```
kubectl top pod --namespace=ingress-nginx
```

## Show all services 

```
kubectl get service
```

Sample output

```
NAME                        TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
kubernetes                  ClusterIP   10.0.0.1       <none>        443/TCP   662d
trading-app-lse-consumer        ClusterIP   10.0.42.48     <none>        80/TCP    573d
trading-app-nys-mapper          ClusterIP   10.0.65.152    <none>        80/TCP    592d
```

## Get services under a namespace

```
kubectl get service --namespace mynamespace001
```

## Get deployments under a namespace

```
kubectl get deployment --namespace mynamespace001
```

Sample output:
```
NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
trading-app-nys-consumer          1/1     1            1           459d
trading-app-lse-broker            0/0     0            0           300d
```


## MS Tutorial
I was trying to follow this MS tutorial, but found it difficult. Very large YAML!
- https://learn.microsoft.com/en-us/azure/aks/tutorial-kubernetes-prepare-app?tabs=azure-cli#before-you-begin
- https://github.com/Azure-Samples/aks-store-demo


---

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

## Converting the Kube config

```
# There are other options besides azurecli. E.g. spn
kubelogin convert-kubeconfig -l azurecli
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
# MS Tutorials

- https://learn.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-application?tabs=azure-cli
- https://learn.microsoft.com/en-us/training/modules/aks-deploy-container-app/
