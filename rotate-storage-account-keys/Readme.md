[[_TOC_]]

# Overview
to be done

---

# Securing your Azure storage accounts and Cosmos accounts
to be done

---

# What is the idea behind key rotation?
to be done

---


# How does the presence of Azure Key Vault for key rotation solution?
to be done

talk about how Azure functions and web apps can seamlessly access Key Vault secrets
stress on another layer of indirection

---


# How does key rotation work?

[show a pic]

---


## Azure PowerShell reference
# Get the keys of a storage account
```
$keys=Get-AzStorageAccountKey -ResourceGroupName $ResourceGroup -Name $DemoAccountName
# Gives the name of the Key1, 'Key1'
$keys[0].KeyName  
# Gives the plain text value of the key
$keys[0].Value

```


## Read a secret from KeyVault
```
Get-AzKeyVaultSecret -VaultName "MyKeyVault" -Name "MyKeyName" -AsPlainText
```

## Get list of all users
```
Get-AzADUser
```


## Get role assignments?
```
#Ensure that $userid is assigned to the Id property of the current user who has logged in
Get-AzRoleAssignment -ObjectId $userid
```

## Key vault access policy
If you want to access the keys in the vault via `Get-AzKeyVaultSecret` then the following is neccessary
```
$PrincipalName="THIS IS THE ACCOUNT WHICH HAS BEEN USED FOR Connect-AzAccount"
Set-AzKeyVaultAccessPolicy -VaultName $KeyVaultName -UserPrincipalName $PrincipalName  -PermissionsToKeys create,import,delete,list,get -PermissionsToSecrets set,delete,get,list -PassThru

```



# What next?
- You got the rotation script to work via CSV
- Clean up the CreateInfra.ps1 script
- Write article
- Do not use default.html
- Write in Readme.md
- Create an images folder
- Keep all script snippets under References






