<#
Just create the APIM and clear all existing end points
Do not add anything more - we will do it in a separate script
#>
Set-StrictMode -Version "2.0"
cls
$ErrorActionPreference="Stop"
#
#Initialize global variables
#
$rgroup="rg-demo-apim-001"
$location="uksouth"
$apim="sauapim-001"
$adminEmail="saurabh_dasgupta@hotmail.com"
$separator="-------------------------------------------------------------"
#
#Initialize global variables above
#
#######################################################################
"Creating resource group $rgroup"
New-AzResourceGroup -Name $rgroup -Location $location -Force
"Resource group $rgroup creted"
$separator
#
#
"Creating new APIM"
New-AzApiManagement -Name $apim -ResourceGroupName $rgroup `
  -Location $location -Organization "Contoso" -AdminEmail $adminEmail

"New APIM created $apim"
$separator
$apimObject=Get-AzAPIManagement -ResourceGroupName $rgroup -Name $apim
"Got context from APIM"
$apiContext = New-AzApiManagementContext -ResourceGroupName $apimObject.resourcegroupname -ServiceName $apimObject.name
#
#Delete all existing API end points
#
"Going to delete all existing APIs"
$allExistingApis=Get-AzApiManagementApi -Context $apiContext
foreach($existingApi in $allExistingApis)
{
    "Deleting API {0}" -f $existingApi.ServiceUrl
    
    Remove-AzApiManagementApi -Context $apiContext -ApiId $existingApi.ApiId
}
"Deletion of API end points complete"
$separator
#
#Delete all existing version sets
#
"Deleting all existing version sets"
$versionSets=Get-AzApiManagementApiVersionSet -Context $apiContext
foreach($versionSet in $versionSets)
{
    "Removing version set {0}" -f $versionSet.DisplayName
    Remove-AzApiManagementApiVersionSet -Context $apiContext -ApiVersionSetId $versionSet.ApiVersionSetId
}
"All existing version sets deleted"
$separator



