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


Guided tutorial
---------------
https://www.cloudsma.com/2019/09/configure-azure-api-management-powershell/

#>

Set-StrictMode -Version "2.0"
cls
$ErrorActionPreference="Stop"
$rgroup="rg-demo-apim"
$location="uksouth"
$apim="sauapim"
$adminEmail="saurabh_dasgupta@hotmail.com"
$apimProduct="Contoso"
#######################################################################
"Creating resource group $rgroup"
New-AzResourceGroup -Name $rgroup -Location $location
"Resource group $rgroup creted"
#
#
"Creating new APIM"
New-AzApiManagement -Name $apim -ResourceGroupName $rgroup `
  -Location $location -Organization "Contoso" -AdminEmail $adminEmail

"New APIM created $apim"

#
#

$apimObject=Get-AzAPIManagement -ResourceGroupName $rgroup -Name $apim
"Got context from APIM"
$apiContext = New-AzApiManagementContext -ResourceGroupName $apimObject.resourcegroupname -ServiceName $apimObject.name

"Creating new product $apimProduct"
$newProduct = New-AzApiManagementProduct -Context $apiContext -ProductId "123" `
-Title "Demo title" -Description "Demo API Product for Contoso" -State "Published" 
"New product $apimProduct created"

#add-AzApiManagementApiToProduct -context $apiContext -ProductId $newproduct.productid -apiid $newapi.id

#
#Get the function app url
#
#"Get function app using Get-AzFunctionApp"
#"Get webapp url using $app.defaulthostname"
 # Find-Module -Filter "az.functions"


 <#
 #Get URL of the Azure function app
 $azwebapp = get-azwebapp -ResourceGroupName yourresourcegroup
 $uri = "https://" + $azwebapp.defaulthostname

 #New API
 $newapi = New-AzApiManagementApi -context $apiContext -name "azure function" -ServiceUrl $uri -protocols @('http','https') -path "testapi"
 New-AzApiManagementOperation -Context $apiContext -ApiId $newapi.apiid -OperationId "operation1" -Name "HttpEndPoint" -Method "POST" -UrlTemplate "/HttpEndPoint"

 #Create API operation
 New-AzApiManagementOperation -Context $apiContext -ApiId $newapi.apiid -OperationId "operation1" -Name "HttpEndPoint" -Method "POST" -UrlTemplate "/HttpEndPoint"

 #>


