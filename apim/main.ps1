#
#The main script for Point2Point infra creation
#https://docs.microsoft.com/en-us/azure/api-management/powershell-create-service-instance
#
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

