. $PSScriptRoot/../common.ps1

Write-Host "Going to create web client job deployment"
kubectl apply --filename "$PSScriptRoot/aks-job.yaml" --namespace $Global:KubernetesNamespace
RaiseCliError -message "Failed to create deployment"
Write-Host "Created the deployment"
