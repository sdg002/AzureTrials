. $PSScriptRoot/../common.ps1

Write-Host "Going to create namespaces"
kubectl apply --filename $PSScriptRoot/namespaces.yaml
RaiseCliError -message "Failed to create namespaces"


Write-Host "Going to create pod"
kubectl apply --filename $PSScriptRoot/pod.yaml --namespace=demoapp
RaiseCliError -message "Failed to create Pod"



