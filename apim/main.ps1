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


How to set subscription required to false?
-------------------------------------------
    $newapi = New-AzApiManagementApi -context $apiContext -name "my azure function" -ServiceUrl $uri -protocols @('https') -path "/" -Verbose -SubscriptionRequired
    $newapi.SubscriptionRequired=$false
    Set-AzApiManagementApi -InputObject $newapi -Name $newapi.Name

The importance of the path parameter while adding an API
--------------------------------------------------------
    When you pass "/blahpath" using the -path parameter of the New-AzApiManagementApi cmdlet, then the URL becomes
    https://sauapim-001.azure-api.net/blahpath/v1/api/customers/234

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


"Getting function app in current resource group"
$azFuncApp=Get-AzFunctionApp -ResourceGroupName $rgroup
"Got function app: {0}" -f $azFuncApp.Name


$uri = "https://"+$azFuncApp.DefaultHostName
"URL of function is $uri"

$newapi = New-AzApiManagementApi -context $apiContext -name "my azure function" -ServiceUrl $uri -protocols @('https') -path "/" -Verbose -SubscriptionRequired
"Added new API"

"Setting subscription required false for api:{0}" -f $newapi.Name
$newapi.SubscriptionRequired=$false
Set-AzApiManagementApi -InputObject $newapi -Name $newapi.Name
#-Context $apiContext -ApiId $newapi.ApiId -SubscriptionRequired $false
"Subscription is not set to false for api:{0}" -f $newapi.Name

#Add A GET operation to the API
New-AzApiManagementOperation -Context $apiContext -ApiId $newapi.apiid -OperationId "operation1" -Name "HttpEndPoint" -Method "GET" -UrlTemplate "/api/Function1"
"Added operation to API"

"----------------------------------------"
"Deleting all existing version sets"
$versionSets=Get-AzApiManagementApiVersionSet -Context $apiContext
foreach($versionSet in $versionSets)
{
    "Removing version set {0}" -f $versionSet.DisplayName
    Remove-AzApiManagementApiVersionSet -Context $apiContext -ApiVersionSetId $versionSet.ApiVersionSetId
}
"All existing version sets deleted"


<#
something wrong below, produces an error
#Add to product
#You were here
#You were able to drop and create new APIs
#But, the line below is failing - adding new API to Product
"Going to add API to product"
add-AzApiManagementApiToProduct -context $apiContext -ProductId $newproduct.productid -apiid $newapi.id
"Added API to product"
#>

#add-AzApiManagementApiToProduct -context $apiContext -ProductId $newproduct.productid -apiid $newapi.id

<#
We need to understand the sub-structure under API
#>
