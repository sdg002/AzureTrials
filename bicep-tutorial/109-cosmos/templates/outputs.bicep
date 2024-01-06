param myparam string
param cosmosaccount string
var mong_cn_string =listConnectionStrings(resourceId('Microsoft.DocumentDB/databaseAccounts/',cosmosaccount),'2023-11-15').connectionStrings[0].connectionString

output myparm string=myparam
output mongo string = mong_cn_string
