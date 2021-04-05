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
$appInsightsName="myappinsights"
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
#Create Application Insights
#
"Creating application insights"
$appInsights=Get-AzApplicationInsights -ResourceGroupName $rgroup -Name $appInsightsName -ErrorAction Continue
if ($appInsights -eq $null)
{
    New-AzApplicationInsights -ResourceGroupName $rgroup -Name $appInsights -location $location
    "Application insights created"
}
else
{
    "Application insights already exists. Not creating"
}
$appInsights=Get-AzApplicationInsights -ResourceGroupName $rgroup -Name $appInsightsName


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
#Attach logger
#
$separator
"Removing existing loggers"
$loggers=Get-AzApiManagementLogger -Context $apiContext 
if ($loggers -ne $null)
{
    "Found existing loggers"
    foreach($logger in $loggers)
    {
        Remove-AzApiManagementLogger -Context $apiContext -LoggerId $logger.LoggerId
        "Removed existing logger"
    }
}
$separator
"Attaching logger"
New-AzApiManagementLogger -Context $apiContext -InstrumentationKey $appInsights.InstrumentationKey -LoggerId $appInsights.Name
"Logger attached"
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



