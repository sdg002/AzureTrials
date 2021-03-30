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


How to get the URL of the Azure function app?
---------------------------------------------
    $azFuncApp=Get-AzFunctionApp -ResourceGroupName $rgroup
    $uri = "https://"+$azFuncApp.DefaultHostName
    #Thsi will give you 'https://mysimpleazurefunc001.azurewebsites.net'

What is the actual Azure function app URL?
------------------------------------------
    https://mysimpleazurefunc001.azurewebsites.net/api/Function1?code=Zaat7Dzw1QIBnv6GqN5zAA9bBMMHa1teaIPQujpX46d2TI20flSoZA==&name=cool

How do we add the above end point to APIM?
------------------------------------------
    $newapi = New-AzApiManagementApi -context $apiContext -name "my azure function" -ServiceUrl $uri -protocols @('http','https') -path "/" -Verbose
    #Add A GET operation to the API
    New-AzApiManagementOperation -Context $apiContext -ApiId $newapi.apiid -OperationId "operation1" -Name "HttpEndPoint" -Method "GET" -UrlTemplate "/api/Function1"
    #Pay attention to the 'path' parameter. We are passing "/" 
    #Pay attention to the '/api/Function1". This comes from the Azure function

#>

Set-StrictMode -Version "2.0"
cls
$ErrorActionPreference="Stop"
$rgroup="rg-demo-apim-001"
$location="uksouth"
$apim="sauapim-001"
$adminEmail="saurabh_dasgupta@hotmail.com"
$productTitle="Demo title of my product"
$productId="123"
#######################################################################
"Creating resource group $rgroup"
New-AzResourceGroup -Name $rgroup -Location $location -Force
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
#
#Delete existing product
#
$existingProduct=Get-AzApiManagementProduct -ProductId $productId -Context $apiContext -ErrorAction Continue
if ($existingProduct -ne $null)
{
    "Deleting product with title:$productTitle and id:$productId"
    Remove-AzApiManagementProduct -ProductId $existingProduct.ProductId  -Context $apiContext -DeleteSubscriptions
}
else
{
    "Not deleting product with title:$productTitle and id:$productId was found"
}
#
#Create new product
#
"Creating new product $productTitle"
$newProduct = New-AzApiManagementProduct -Context $apiContext -ProductId $productId `
-Title $productTitle -Description "Demo API Product for Contoso" -State "Published" 
"New product $productTitle created"
#
#
#
"Going to delete all existing APIs"
$allExistingApis=Get-AzApiManagementApi -Context $apiContext
foreach($existingApi in $allExistingApis)
{
    "Deleting API {0}" -f $existingApi.ServiceUrl
    
    Remove-AzApiManagementApi -Context $apiContext -ApiId $existingApi.ApiId
}
"Deletion complete"



$azFuncApp=Get-AzFunctionApp -ResourceGroupName $rgroup

$uri = "https://"+$azFuncApp.DefaultHostName
 
$newapi = New-AzApiManagementApi -context $apiContext -name "my azure function" -ServiceUrl $uri -protocols @('http','https') -path "/" -Verbose

#Add A GET operation to the API
New-AzApiManagementOperation -Context $apiContext -ApiId $newapi.apiid -OperationId "operation1" -Name "HttpEndPoint" -Method "GET" -UrlTemplate "/api/Function1"

#Add to product
#You were here
#You were able to drop and create new APIs
#But, the line below is failing - adding new API to Product
add-AzApiManagementApiToProduct -context $apiContext -ProductId $newproduct.productid -apiid $newapi.id

#add-AzApiManagementApiToProduct -context $apiContext -ProductId $newproduct.productid -apiid $newapi.id

#
#Get the function app url
#
#"Get function app using Get-AzFunctionApp"
#"Get webapp url using $app.defaulthostname"
 # Find-Module -Filter "az.functions"

