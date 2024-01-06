
@minLength(3)
param name string

@minLength(3)
param storageaccount string


var resourceName='${storageaccount}/default/${name}'

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-09-01' = {
  name: resourceName
}

//https://stackoverflow.com/questions/54411072/how-do-i-deploy-file-share-within-storage-account-using-arm-template
