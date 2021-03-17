#
#The main script for Point2Point infra creation
#
Set-StrictMode -Version "2.0"
cls
$rgroup="rg-demo-point2point"
$location="uksouth"
#####################################################
New-AzResourceGroup -Name $rgroup -Location $location



