. $PSScriptRoot\Common.ps1
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
#Create the version set for Customers
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
#Add Orders API
#
"Adding new API orders"
$newapiOrders = New-AzApiManagementApi -context $apiContext -name "Orders end point" -ServiceUrl $uri -Description "Orders end pointdescription"  -protocols @('https') -path "/" -Verbose `
 -ApiVersionSetId $ordersVersionSet.ApiVersionSetId  -ApiVersion v1
"Added new API "
$newapiOrders
$newapiOrders.SubscriptionRequired=$false
Set-AzApiManagementApi -InputObject $newapiOrders -Name $newapiOrders.Name
$separator
#
#Add GetOrders operation
#
$customerId=CreateStringParameter -name "customerid" -description "customer id"
New-AzApiManagementOperation -Context $apiContext -ApiId $newapiOrders.apiid -OperationId "GetOrders" -Name "GetOrders" -Method "GET" `
-UrlTemplate "/api/customers/{customerid}/orders"  -TemplateParameters @($customerid)
"Added new operation to get orders"
$separator
#
#Add GetOrderLineItems operation
#
$orderId=CreateStringParameter -name "orderid" -description "order id"
New-AzApiManagementOperation -Context $apiContext -ApiId $newapiOrders.apiid -OperationId "GetOrderLineItems" -Name "GetOrderLineItems" -Method "GET" `
-UrlTemplate "/api/customers/{customerid}/{orderid}/orderlineitems"  -TemplateParameters @($customerId,$orderId)
"Added new operation to get order line items"

<#

#>

#
#Add Customers API
#
"Adding new API Customers"
$newapiCustomers = New-AzApiManagementApi -context $apiContext -name "Customers end point" -ServiceUrl $uri -Description "Customers end point description" `
 -protocols @('https') -path "/customerspath" -Verbose `
 -ApiVersionSetId $customersVersionSet.ApiVersionSetId  -ApiVersion v1
"Added new API "
$newapiCustomers
$newapiCustomers.SubscriptionRequired=$false
Set-AzApiManagementApi -InputObject $newapiCustomers -Name $newapiCustomers.Name
"Added new API"
$separator
#
#Add GetCustomer operation
#
$customerId=CreateStringParameter -name "customerid" -description "customer id"
New-AzApiManagementOperation -Context $apiContext -ApiId $newapiCustomers.apiid -OperationId "GetCustomers" -Name "GetCustomers" -Method "GET" `
-UrlTemplate "/api/customers/{customerid}"  -TemplateParameters @($customerid)
"Added new operation to get orders"
$separator

<#
You were here, 
    Try out policies

#>
