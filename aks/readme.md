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


