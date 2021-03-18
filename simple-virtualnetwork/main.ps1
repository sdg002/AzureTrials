#
#Script demonstrates creation of a virtual network with 2 subnets using ARM templates
#
Set-StrictMode -Version "2.0"
cls
$rgroup="rg-demo-point2point"
$location="uksouth"
$vnet="demopoint2sitevnet"
#####################################################
"Creating resource group $rgroup"
New-AzResourceGroup -Name $rgroup -Location $location
"Resource group $rgroup creted"
#
#Create VNET
#
"Creating virtual network"
New-AzResourceGroupDeployment -TemplateParameterFile $PSScriptRoot\arm-vnet\parameters.json -TemplateFile $PSScriptRoot\arm-vnet\template.json -ResourceGroupFromTemplate $rgroup -virtualNetworkName $vnet -ResourceGroupName $rgroup
"Virtual network $vnet"
