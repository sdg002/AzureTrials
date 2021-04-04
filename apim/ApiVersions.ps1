<#
In this I am experimenting with versions of APIM

You should run main.ps1 before running this script

#>

Set-StrictMode -Version "2.0"
cls
$ErrorActionPreference="Stop"
$rgroup="rg-demo-apim-001"
$location="uksouth"
$apim="sauapim-001"

$apimObject=Get-AzAPIManagement -ResourceGroupName $rgroup -Name $apim
"Got context from APIM"
$apiContext = New-AzApiManagementContext -ResourceGroupName $apimObject.resourcegroupname -ServiceName $apimObject.name
"Got API context"
$apiContext
"----------------------------------------"
"Deleting all existing version sets"
$versionSets=Get-AzApiManagementApiVersionSet -Context $apiContext
foreach($versionSet in $versionSets)
{
    "Removing version set {0}" -f $versionSet.DisplayName
    Remove-AzApiManagementApiVersionSet -Context $apiContext -ApiVersionSetId $versionSet.ApiVersionSetId
}
"All existing version sets deleted"
"------------------------------------------------------------------------"
"Creating new version set"
$v2VersionSet=New-AzApiManagementApiVersionSet -Context $apiContext  -Name "v2" -Scheme Segment -Description "My v2 version"
"New version set created"
$v2VersionSet
"------------------------------------------------------------------------"

"Getting function app in current resource group"
$azFuncApp=Get-AzFunctionApp -ResourceGroupName $rgroup
"Got function app: {0}" -f $azFuncApp.Name


$uri = "https://"+$azFuncApp.DefaultHostName
"URL of function is $uri"
"------------------------------------------------------------------------"
"Adding new API"
$newapi = New-AzApiManagementApi -context $apiContext -name "my azure function" -ServiceUrl $uri -protocols @('https') -path "/blah" -Verbose -ApiVersionSetId $v2VersionSet.ApiVersionSetId
"Added new API"


New-AzApiManagementOperation -Context $apiContext -ApiId $newapi.apiid -OperationId "operation1" -Name "HttpEndPoint" -Method "GET" -UrlTemplate "/api/Function1" 
