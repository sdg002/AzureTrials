. $PSScriptRoot/../common.ps1

Write-Host "Going to create pod"
kubectl apply --filename $PSScriptRoot/pod.yaml --namespace=demoapp
RaiseCliError -message "Failed to create Pod"
Write-Host "Created the pod"

Write-Host "Going to create deployment"
kubectl apply --filename "$PSScriptRoot/aks-deployment.yaml" --namespace demoapp
RaiseCliError -message "Failed to create deployment"
Write-Host "Created the deployment"
