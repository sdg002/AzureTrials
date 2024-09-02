. $PSScriptRoot/../common.ps1

Write-Host "Going to create namespaces"

kubectl apply --filename $PSScriptRoot/namespaces.yaml
