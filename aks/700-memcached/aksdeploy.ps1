. $PSScriptRoot/../common.ps1

Write-Host "Going to create memcached deployment"
kubectl apply --filename "$PSScriptRoot/aks-memcached-deployment.yaml" --namespace $Global:KubernetesNamespace
RaiseCliError -message "Failed to create deployment"

Write-Host "Going to create memcached service"
kubectl apply --filename "$PSScriptRoot/aks-memcached-service.yaml" --namespace $Global:KubernetesNamespace
RaiseCliError -message "Failed to create service"
