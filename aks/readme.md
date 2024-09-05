[[_TOC_]]

# My lessons on Azure AKS


# 101-deploy-aks
In this section we deploy an AKS using the simplest possible Azure CLI commands and do some experiments using `Kubectl` and `KubeLogin`.


# 200-create-namespace

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

## Get the YAML of a service

```
kubectl get service myservice --output yaml
```

## Get the YAML of a deployment

```
kubectl get deployment mydeployment001 --namespace mynamespace001 --output yaml
```



## MS Tutorial
I was trying to follow this MS tutorial, but found it difficult. Very large YAML!
- https://learn.microsoft.com/en-us/azure/aks/tutorial-kubernetes-prepare-app?tabs=azure-cli#before-you-begin
- https://github.com/Azure-Samples/aks-store-demo


---

# 300-Deploy-web-app
In this lab we will deply a simple Flask web app.

## Where is the code for the web app ?

[app.py](demo-flask-app/src/app.py)


## Understanding the YAML files

We need the following
- deployment YAML (has the container image name, environment variables)
- service YAML (has the outer ports, load balancer)

The `selector/matchLabels` element must point to the name of the pod through `name: mypod`

## Good samples on YAML
Explains the nuances of selector labels
https://spacelift.io/blog/kubernetes-deployment-yaml


## Getting the external IP address

![external ip address](docs/images/portal-externalip.png)

## View the logs

![alt text](docs/images/workloads.png)

![log view](docs/images/logview.png)


## Image pull policy

### No policy specified
I updated the image , the tag remained unchanged. I did the AKS deployment. 
**Outcome** - The new image was not picked up.

### Always

If I were to simply push a modified image (with same tag) then AKS does not update itself. However, if run the following command, then AKS does pull the new image
```
kubectl rollout restart deployment example-flask-app --namespace demoapp
```
In the above example, the name of the deployment can be obtained from the following command:

```
kubectl get deployments --namespace demoapp
```

---

# 400-Deploy a job

## What is a Job in Kubernetes ?
Jobs represent one-off tasks that run to completion and then stop. See [Kubernetes documentation](https://kubernetes.io/docs/concepts/workloads/controllers/job/#completion-mode).

## Where is the source code ?
[sourc code](demo-job/src/main.py)


## How to get a list of jobs in a namespace ?

```
kubectl get jobs  --namespace demoapp
```


## Lessons learnt

- Kubernetes has Jobs and ChronJob
- The `restartPolicy` of a job can be `Never` or `OnFailure`
- The `backoffLimit` specifies the number of retries before a job is considered a failure.

## How to restart a job ?

You need this to kick start a job
```
kubectl delete job example-python-job --namespace demoapp
kubectl apply -f job.yaml
```

## How to view the logs ?

```
kubectl logs YOUR_POD_NAME --namespace demoapp
# The YOUR_POD_NAME is the output from kubectl get pods
```

## Further reading

https://medium.com/google-cloud/kubernetes-running-background-tasks-with-batch-jobs-56482fbc853


---

# 500-Chron job

## Azure portal does not show up the cron job
This could be because of the ephemeral nature of a container. It dies off immediately after the job is done.

## How to override the CMD of the Dockerfile ?
Specify the `commmand` element in the YAML of the cron job deployment

```
command: [ "python", "src/chronmain.py" ]
```

## How to view all cron jobs ?

```
kubectl get cronjobs --namespace demoapp
```

Example output:

```
NAME            SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
demo-cron-job   */2 * * * *   False     0        33s             28m
```

## How to view the logs ?

**Step-1**-Get the list of cron jobs 

```
kubectl get jobs --namespace demoapp
```

Example output:
```
NAME                     COMPLETIONS   DURATION   AGE
demo-cron-job-28758896   1/1           3s         5m43s
demo-cron-job-28758898   1/1           3s         3m43s
demo-cron-job-28758900   1/1           3s         103s
```

**Step-2**-Fetch the logs for the specified instance

```
kubectl logs job/demo-cron-job-28758900 --namespace demoapp
```
Example output:

```
Begin
Current time is 2024-09-05 11:00:01.077809
End
```

## Delete a Cron job

```
kubectl delete cronjobs demo-cron-job --namespace demoapp
```

Example output:

```
cronjob.batch "demo-cron-job" deleted
```

---

# 600-internal-http-communication

## Objective
A python worker which talks to an internal python Flask web app


## How to get the IP address of a web app ?


Get all services
```
kubectl get svc --namespace demoapp
```

Sample output:
```
NAME                                TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
flask-app-service                ClusterIP   10.0.45.201    <none>        80/TCP    461d
some-other-service               ClusterIP   10.0.143.254   <none>        80/TCP    454d
```

Get specific service
```
kubectl get svc flask-app-service

# Can use -o json option as well
```

Sample output:

```
NAME              TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
flask-app-service   ClusterIP   10.0.226.215   <none>        80/TCP    462d
```

The `CLUSTER-IP` and the `PORT` combination gives us the complete end point

## Using the internal FQDN

If a service with the name `my-web-app` is deployed to the namespace `my-demo-app` then the internal hostname is `my-web-app.my-demo-app.svc.cluster.local`

### Step-1-Get the pod name

```
kubectl get pods --namespace demoapp
```

### Step-2-Open a remote shell into the pod

```
kubectl exec -it POD_NAME --namespace demoapp sh
```

### Step-3-Run the ping command

```
ping SERVICE_NAME.NAMESPACE.svc.cluster.local
```

### Step-4-Run the Python Socket to connect

Run `pyhon` within the `sh` of the pod

```
import socket
s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("flask-app-service.demoapp.svc.cluster.local",80))
```



## kubectl create configmap (TO BE DONE)

### 1-Deploy the first web app

```
kubectl apply -f my-web-app-service.yaml
```

### 2-Get the Cluster IP

```
kubectl get svc my-web-app -o jsonpath='{.spec.clusterIP}'
```

### 3-Create the Config map

```
kubectl create configmap webapp-config --from-literal=WEBAPP_CLUSTERIP=$(kubectl get svc my-web-app -o jsonpath='{.spec.clusterIP}'
```

### Use the ConfigMap

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-job
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: my-job
    spec:
      containers:
      - name: my-job-container
        image: my-job-image
        env:
        - name: WEBAPP_CLUSTERIP
          valueFrom:
            configMapKeyRef:
              name: webapp-config
              key: WEBAPP_CLUSTERIP

```


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

## MS documentation on doing the KubeCtl login sequence
https://learn.microsoft.com/en-us/azure/aks/kubelogin-authentication


---


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

# Lessons learnt

## How to use az acr build command ?
This is convenient because we do not need local docker
```
az acr build --registry NAME_OF_ACR --image demo:v1 ABSOLUTE_PATH_TO_FOLDER_WITH_DOCKERFILE
```


## Configuring a Json schema store
I was tyring to get the intellisense sorted for YAML files inside of VSCODE.
I installed Red hat extension,but it did not reflect. Finally, the steps were:
1. Created a `settings.json` inside the `.vscode` folder
1. Added the following to the settings.json:


```json
{
    "yaml.schemas": {
        "Kubernetes": ["*.yaml"],
    },
    "yaml.schemaStore.enable": true
}
```

This SFO was useful:
https://stackoverflow.com/questions/68811153/yaml-support-for-kubernetes-in-vscode
