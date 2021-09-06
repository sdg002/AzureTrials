Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"
$PathToScript=$PSScriptRoot
$CSvFile=Join-Path -Path $PathToScript -ChildPath "ListOfStorageAccounts.csv"
$KeyVaultName="Sau-MyKeyVaultName"

function DoStuff () {
    $ResourceGroup="rg-demo-rotation-storageaccount"
    $DemoAccountName="demostoaccount001"
    
    $Keys=Get-AzStorageAccountKey -Name $DemoAccountName -ResourceGroupName $ResourceGroup
    $Keys
    
    New-AzStorageAccountKey -ResourceGroupName $ResourceGroup -Name $DemoAccountName -KeyName "key1"
        
}
function CreateStorageAccountConnectionString($StorageAccountName,$StorageAccountResourceGroup,$StorageAccountKey){
    $format="DefaultEndpointsProtocol=https;AccountName={0};AccountKey={1};EndpointSuffix=core.windows.net"
    $cnstring= $format -f $StorageAccountName, $StorageAccountKey
    return $cnstring
}

function  FindWhichKeyToRote 
{
    param ($currentkeyvaultvalue,$StorageAccountName,$StorageAccountResourceGroup)
    $StorageAccountKeys=Get-AzStorageAccountKey -ResourceGroupName $StorageAccountResourceGroup -Name $StorageAccountName    
    Write-Host ("Storage account key 0 = '{0}'" -f $StorageAccountKeys[0].Value)
    Write-Host ("Storage account key 1 = '{0}'" -f $StorageAccountKeys[1].Value)

    $OldStorageAccountCnString = CreateStorageAccountConnectionString -StorageAccountName $StorageAccountName -StorageAccountResourceGroup $StorageAccountResourceGroup -StorageAccountKey $currentkeyvaultvalue
    $CandidateStorageAccountCnString0 = CreateStorageAccountConnectionString -StorageAccountName $StorageAccountName -StorageAccountResourceGroup $StorageAccountResourceGroup -StorageAccountKey $StorageAccountKeys[0].Value
    $CandidateStorageAccountCnString1 = CreateStorageAccountConnectionString -StorageAccountName $StorageAccountName -StorageAccountResourceGroup $StorageAccountResourceGroup -StorageAccountKey $StorageAccountKeys[1].Value
    $WhichKeyNameToRotate=$null
    [int]$WhichKeyIndexToRotate=-1
    if ($OldStorageAccountCnString -eq $CandidateStorageAccountCnString0)
    {
        $WhichKeyNameToRotate=$StorageAccountKeys[1].KeyName
        $WhichKeyIndexToRotate=1
    }
    else 
    {
        $WhichKeyNameToRotate=$StorageAccountKeys[0].KeyName
        $WhichKeyIndexToRotate=0
    }

    $results=@{}
    $results.KeyName=$WhichKeyNameToRotate
    $results.KeyIndex=$WhichKeyIndexToRotate
    return $results
}

function ProcessCsvItems {
    param ($lineitems)
    
    foreach($lineitem in $lineitems)
    {

        $StorageAccountName=$lineitem.StorageAccountName
        $StorageAccountResourceGroup=$lineitem.StorageAccountResourceGroup
        $KeyVaultSecretName=$lineitem.KeyVaultSecretName
        Write-Host "Processing storage account name: '$StorageAccountName' , resource group: '$StorageAccountResourceGroup' , key vault name: '$KeyVaultSecretName' "

        #$StorageAccountKeys=Get-AzStorageAccountKey -ResourceGroupName $StorageAccountResourceGroup -Name $StorageAccountName
        $keyVaultSecret=Get-AzKeyVaultSecret -VaultName Sau-MyKeyVaultName -Name $KeyVaultSecretName -AsPlainText
        if ($null -eq $keyVaultSecret)
        {
            Write-Host  "No key vault entry found , initializing the key vault with secret"
            #No key vault entry found, initialize with storage account key
            $StorageAccountKeyValue=$StorageAccountKeys[0].Value
            $StorageAccountCnString = CreateStorageAccountConnectionString -StorageAccountName $StorageAccountName -StorageAccountResourceGroup $StorageAccountResourceGroup -StorageAccountKey $StorageAccountKeyValue
            $Secret=ConvertTo-SecureString -String $StorageAccountCnString -AsPlainText -Force
            Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $KeyVaultSecretName -SecretValue $Secret
            continue
        }


        Write-Host "Key vault secret was found '$keyVaultSecret'"
        $whatToRotate= FindWhichKeyToRote -currentkeyvaultvalue $keyVaultSecret -StorageAccountName $StorageAccountName -StorageAccountResourceGroup $StorageAccountResourceGroup
        $WhichKeyNameToRotate=$whatToRotate.KeyName
        $WhichKeyIndexToRotate=$whatToRotate.KeyIndex

        Write-Host "Going to rotate key name $WhichKeyNameToRotate , this is the index $WhichKeyIndexToRotate"
        $NewStorageAccountKeys=New-AzStorageAccountKey -Name $StorageAccountName -ResourceGroupName $StorageAccountResourceGroup -KeyName $WhichKeyNameToRotate
        Write-Host "Rotated key $WhichKeyNameToRotate"
        $NewStorageAccountKeyValueToPlaceInKeyVault=$NewStorageAccountKeys.Keys[$WhichKeyIndexToRotate].Value
        $NewStorageAccountCnStringToPlaceInKeyVault =  CreateStorageAccountConnectionString -StorageAccountName $StorageAccountName -StorageAccountResourceGroup $StorageAccountResourceGroup -StorageAccountKey $NewStorageAccountKeyValueToPlaceInKeyVault
        Write-Host "New key value after rotation '$NewStorageAccountCnStringToPlaceInKeyVault'"
        $NewSecret=ConvertTo-SecureString -String $NewStorageAccountCnStringToPlaceInKeyVault -AsPlainText -Force
        Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $KeyVaultSecretName -SecretValue $NewSecret
        Write-Host "New key vault secret is $NewStorageAccountCnStringToPlaceInKeyVault"
        Write-Host ("Storage account key 0 = '{0}'" -f $NewStorageAccountKeys.Keys[0].Value)
        Write-Host ("Storage account key 1 = '{0}'" -f $NewStorageAccountKeys.Keys[1].Value)
        Write-Host "------------"

    }    
}



Write-Host "$PathToScript"
$CsvItems=Import-Csv -Path $CSvFile
ProcessCsvItems -lineitems $CsvItems


