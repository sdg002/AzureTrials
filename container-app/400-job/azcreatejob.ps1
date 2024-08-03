. $PSScriptRoot/commonvariables.ps1


$UrlRegistry=GetAzureContainerRegisryLoginUrl
Write-Host "Url of registry is $UrlRegistry"

$acaEnvironment = (az resource show --resource-group $Global:ResourceGroup --name $Global:ContainerAppsEnvironment --resource-type "Microsoft.App/managedEnvironments") | ConvertFrom-Json
Write-Host "Id of Container App Environment is"
$acaEnvironment.Id


& az containerapp job create --name $Global:ContainerApp001 --resource-group $Global:ResourceGroup --trigger-type Manual `
    --replica-timeout 5 `
    --replica-retry-limit 2 `
    --replica-completion-count 1 `
    --parallelism 1 `
    --image $Global:LocalImageName `
    --environment $acaEnvironment.Id `
    --registry-server $UrlRegistry


<#
    --workload-profile-name "Consumption" `

#>
