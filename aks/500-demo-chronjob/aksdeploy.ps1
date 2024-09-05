. $PSScriptRoot/../common.ps1

Write-Host "Going to create cron job deployment"
kubectl apply --filename "$PSScriptRoot/aks-cronjob.yaml" --namespace $Global:KubernetesNamespace
RaiseCliError -message "Failed to create deployment"
Write-Host "Created the deployment"
