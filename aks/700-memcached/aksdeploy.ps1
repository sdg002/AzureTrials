. $PSScriptRoot/../common.ps1

Write-Host "Going to create memcached deployment"
kubectl apply --filename "$PSScriptRoot/aks-memcached-deployment.yaml" --namespace $Global:KubernetesNamespace
RaiseCliError -message "Failed to create deployment"

Write-Host "Going to create memcached service"
kubectl apply --filename "$PSScriptRoot/aks-memcached-service.yaml" --namespace $Global:KubernetesNamespace
RaiseCliError -message "Failed to create service"

Write-Host "Going to create memcached writer job deployment"
kubectl apply --filename "$PSScriptRoot/aks-cronjob-memcached-writer.yaml" --namespace $Global:KubernetesNamespace
RaiseCliError -message "Failed to create deployment"
Write-Host "Created the deployment"


Write-Host "Going to create flaks app deployment"
kubectl apply --filename "$PSScriptRoot/aks-flask-app.yaml" --namespace demoapp
RaiseCliError -message "Failed to create deployment"

Write-Host "Going to create flask app service"
kubectl apply --filename "$PSScriptRoot/aks-flask-app-service.yaml" --namespace demoapp
RaiseCliError -message "Failed to create service"
