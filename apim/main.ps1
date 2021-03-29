<#
The main script for Point2Point infra creation

Important links
---------------

How to create a new APIM?
-------------------------
https://docs.microsoft.com/en-us/azure/api-management/powershell-create-service-instance


Understanding the terminology of APIM
---------------------------------------
https://docs.microsoft.com/en-us/azure/api-management/api-management-terminology#term-definitions

Powershell reference for APIM
------------------------------
https://docs.microsoft.com/en-us/powershell/module/az.apimanagement/new-azapimanagementproduct?view=azps-5.7.0

$apimContext = New-AzApiManagementContext -ResourceGroupName "Api-Default-WestUS" -ServiceName "contoso"
New-AzApiManagementProduct -Context $apimContext -ProductId "0123456789" -Title "Starter" -Description "Starter Product" -LegalTerms "Free for all" -SubscriptionRequired $False -State "Published"

#>

Set-StrictMode -Version "2.0"
cls
$ErrorActionPreference="Stop"
$rgroup="rg-demo-apim"
$location="uksouth"
$apim="sauapim"
$adminEmail="saurabh_dasgupta@hotmail.com"
#######################################################################
"Creating resource group $rgroup"
New-AzResourceGroup -Name $rgroup -Location $location
"Resource group $rgroup creted"
#
#
"Creating new APIM"
New-AzApiManagement -Name $apim -ResourceGroupName $rgroup `
  -Location $location -Organization "Contoso" -AdminEmail $adminEmail

