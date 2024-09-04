. $PSScriptRoot/../common.ps1

Write-Host "Going to create deployment"
kubectl apply --filename "$PSScriptRoot/aks-deployment.yaml" --namespace demoapp
RaiseCliError -message "Failed to create deployment"
Write-Host "Created the deployment"
