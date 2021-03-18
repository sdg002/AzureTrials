#
#The main script for Point2Point infra creation
#
Set-StrictMode -Version "2.0"
cls
$ErrorActionPreference="Stop"

#
#Follow the MSDN link to create VNET and Gateway using PS
#https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-point-to-site-rm-ps
#
$VNetName  = "MyVirtualNetwork1"
$FESubName = "FrontEndSubnet"
$GWSubName = "GatewaySubnet"
$VNetPrefix = "10.1.0.0/16"
$FESubPrefix = "10.1.0.0/24"
$GWSubPrefix = "10.1.255.0/27"
$VPNClientAddressPool = "172.16.201.0/24"
$RG = "rg-point2point-mssample"
$Location = "uksouth"
$GWName = "VNet1Gateway"
$GWIPName = "VNet1GatewayIp"
$GWIPconfName = "gwipconf"
$DNS = "10.2.1.4"
#
#
"Going to create resource group $RG"
New-AzResourceGroup -Name $RG -Location $Location
"$RG created"
#
#
$fesub = New-AzVirtualNetworkSubnetConfig -Name $FESubName -AddressPrefix $FESubPrefix
$gwsub = New-AzVirtualNetworkSubnetConfig -Name $GWSubName -AddressPrefix $GWSubPrefix
#
#
"Going to create virtual network $VNetName"
New-AzVirtualNetwork `
   -ResourceGroupName $RG `
   -Location $Location `
   -Name $VNetName `
   -AddressPrefix $VNetPrefix `
   -Subnet $fesub, $gwsub `
   -DnsServer $DNS
"Virtual network $VNetName created"
#
#
"Allocating public ip address"
$vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $RG
$subnet = Get-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet
$pip = New-AzPublicIpAddress -Name $GWIPName -ResourceGroupName $RG -Location $Location -AllocationMethod Dynamic
$ipconf = New-AzVirtualNetworkGatewayIpConfig -Name $GWIPconfName -Subnet $subnet -PublicIpAddress $pip
"Allocating public ip address completed"

#
#
"Creating gateway $GWName"
New-AzVirtualNetworkGateway -Name $GWName -ResourceGroupName $RG `
    -Location $Location -IpConfigurations $ipconf -GatewayType Vpn `
    -VpnType RouteBased -EnableBgp $false -GatewaySku VpnGw1 -VpnClientProtocol "IKEv2"
"Gateway $GWName created"
#
#
$Gateway=Get-AzVirtualNetworkGateway -Name $GWName -ResourceGroup $RG
Set-AzVirtualNetworkGateway -VirtualNetworkGateway $Gateway -VpnClientAddressPool $VPNClientAddressPool
