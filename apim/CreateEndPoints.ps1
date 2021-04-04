<#
This script assumes that APIM instance has been created
This script will do the actual work
    -Create API end points
    -Create API version sets
#>
Set-StrictMode -Version "2.0"
Clear-Host
$ErrorActionPreference="Stop"
#
#Initialize global variables
#
$rgroup="rg-demo-apim-001"
$location="uksouth"
$apim="sauapim-001"
$separator="-------------------------------------------------------------"
#
#Initialize global variables above
#
$separator
$apimObject=Get-AzAPIManagement -ResourceGroupName $rgroup -Name $apim
"Got context from APIM"
$apiContext = New-AzApiManagementContext -ResourceGroupName $apimObject.resourcegroupname -ServiceName $apimObject.name
"Got API context"
$apiContext
#
#Create the version set for Orders
#
$separator
"Creating new version set for Orders"
$ordersVersionSet=New-AzApiManagementApiVersionSet -Context $apiContext  -Name "OrdersVersionSet" -Scheme Segment -Description "My Orders version set"
"New version set for Orders created"
$ordersVersionSet
#
#Create the version set for Orders
#
$separator
"Creating new version set for Customers"
$customersVersionSet=New-AzApiManagementApiVersionSet -Context $apiContext  -Name "CustomersVersionSet" -Scheme Segment -Description "My Customers version set"
"New version set for Orders created"
$customersVersionSet
#
#Get a reference to the Function App
#
$separator
"Getting function app in current resource group"
$azFuncApp=Get-AzFunctionApp -ResourceGroupName $rgroup
"Got function app: {0}" -f $azFuncApp.Name
$uri = "https://"+$azFuncApp.DefaultHostName
"URL of function is $uri"
#
#Add Orders end point
#
"Adding new API"
$newapiOrders = New-AzApiManagementApi -context $apiContext -name "Orders end point" -ServiceUrl $uri -Description "Orders end pointdescription"  -protocols @('https') -path "/" -Verbose `
 -ApiVersionSetId $ordersVersionSet.ApiVersionSetId  -ApiVersion v1
"Added new API "
$newapiOrders
$newapiOrders.SubscriptionRequired=$false
Set-AzApiManagementApi -InputObject $newapiOrders -Name $newapiOrders.Name


$RID = New-Object -TypeName Microsoft.Azure.Commands.ApiManagement.ServiceManagement.Models.PsApiManagementParameter
$RID.Name = "id"
$RID.Description = "Resource identifier"
$RID.Type = "string"

New-AzApiManagementOperation -Context $apiContext -ApiId $newapiOrders.apiid -OperationId "GetOrders" -Name "GetOrders" -Method "GET" `
-UrlTemplate "/api/customers/{id}/orders"  -TemplateParameters @($RID)
"Added new operation to get orders"


<#
You were here, add end point for Customers
#>
