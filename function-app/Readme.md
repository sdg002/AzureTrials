# What is this project about?
Demonstrates the following:
- Deploy an Azure function consumption plan
- Deploy 2 App functions using this plan
- Set custom configuration properties

# How is it happening?
There is an ARM template, which has been stripped off ApplicationInsights and Function App. The ARM template is being deployed with right parameters

# Where did I get this ARM template?
- Follow the steps using Azure Portal for creating an Azure Function
- Stop short of actually creating the Function
- Grab the ARM and the parameters
- Strip it off Plan and storage account

# How to run?
- Open a PowerShell core session
- Ensure you have the Az.Functions module
- Ensure you have done a `Connect-AzAccount`
- Navigate to this folder
- Run `deploy.ps`

# How to zip deploy an Azure Function from local workstation?
## First step
You should have created the Plan and App by running `deploy.ps1`

## Compile and publish
```
dotnet publish --configuration release --output c:\truetemp\yahoo\
```
or

```
dotnet publish  DemoFunctionOnCustomAzurePlan\DemoFunctionOnCustomAzurePlan.csproj -c release  --output c:\truetemp\yahoo1

```

## Create a ZIP from the published files
```
[io.compression.zipfile]::CreateFromDirectory($publishFolder, $publishZip)
```

## Upload the ZIP
```
$zip="C:\truetemp\deploy\myapp.zip"
$ResourceGroup="rg-demo-consumptionfunction-plan-and-app"
$FirstFunctionApp="mydemofunctionapp001"
az functionapp deployment source config-zip -g $resourceGroup -n $FirstFunctionApp --src $zip


```
