using Azure.Identity;
using Azure.ResourceManager;
using Microsoft.Data.SqlClient;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

namespace IntegrationTests
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public async Task ConnectAndFetchDataSet()
        {
            try
            {
                string generalAccessToken = await GetAzureAccessToken();
                string dbAccessToken = await GetDatabaseAccessToken();
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        [TestMethod]
        public async Task ConnectToSql()
        {
            //This worked
            try
            {
                var dbScope = "https://database.windows.net";

                var creds = new DefaultAzureCredential();
                var scopes = new string[] { dbScope };
                var tenantId = "e66fc46b-2666-4ea3-984d-bb30c06f2c75"; //The tenant id is important
                var ctx = new Azure.Core.TokenRequestContext(scopes: scopes, tenantId: tenantId);

                var token = await creds.GetTokenAsync(requestContext: ctx);

                //the token works

                string server = "testsynapse-dev-ondemand.sql.azuresynapse.net";
                var builder = new SqlConnectionStringBuilder();
                builder.DataSource = server;
                builder.InitialCatalog = "myserverlessdb";
                var cnString = builder.ConnectionString;

                using (var cn = new SqlConnection(cnString))
                {
                    cn.AccessToken = token.Token;
                    using (var cmd = new SqlCommand("SELECT * FROM Address ORDER BY personid DESC", cn))
                    {
                        await cn.OpenAsync();
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                var personid = await reader.GetFieldValueAsync<int>(0);
                                var city = await reader.GetFieldValueAsync<string>(1);
                                Trace.WriteLine($"{personid},{city}");
                                //Trace.TraceInformation("{0} {1}", reader.GetString(0), reader.GetString(1));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        [TestMethod]
        public async Task ConnectToSqlUsingAzureCli()
        {
            //This worked
            try
            {
                var token = await GetDatabaseAccessTokenUsingAureCli();

                //the token works

                string server = "testsynapse-dev-ondemand.sql.azuresynapse.net";
                var builder = new SqlConnectionStringBuilder();
                builder.DataSource = server;
                builder.InitialCatalog = "myserverlessdb";
                var cnString = builder.ConnectionString;

                using (var cn = new SqlConnection(cnString))
                {
                    cn.AccessToken = token;
                    using (var cmd = new SqlCommand("SELECT * FROM Address ORDER BY personid DESC", cn))
                    {
                        await cn.OpenAsync();
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                var personid = await reader.GetFieldValueAsync<int>(0);
                                var city = await reader.GetFieldValueAsync<string>(1);
                                Trace.WriteLine($"{personid},{city}");
                                //Trace.TraceInformation("{0} {1}", reader.GetString(0), reader.GetString(1));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        [TestMethod]
        public async Task GetDefaultSubscription_And_TenantId_AzureCli_Credential_WorkInProgress()
        {
            try
            {
                var creds = new AzureCliCredential();
                var armClient = new ArmClient(creds); //Pass defaultSubscriptionId via environment
                //Pass resource group via environment variable, pass synapse name via environment variable
                //Get the synapse connection string
                var defSub = await armClient.GetDefaultSubscriptionAsync();
                //This works - but the subscription is not the same as what you get with "az account show"
                Trace.WriteLine($"Subscription={defSub.Data.DisplayName}");
                //checked with options

                var scopes = new string[] { "https://management.core.windows.net/" };
                //var tenantId = "e66fc46b-2666-4ea3-984d-bb30c06f2c75"; //The tenant id is important
                var tenantId = defSub.Data.TenantId.ToString();
                var ctx = new Azure.Core.TokenRequestContext(scopes: scopes, tenantId: tenantId);

                var token = await creds.GetTokenAsync(ctx);
                Trace.WriteLine(token.Token.ToString());

                var allSubs = armClient.GetSubscriptions();
                var allSubsPaged = allSubs.GetAllAsync();

                await foreach (var sub in allSubsPaged)
                {
                    Trace.WriteLine($"Name={sub.Data.DisplayName}  Id={sub.Data.SubscriptionId}");
                }

                //return token.Token;
            }
            catch (Exception ex)
            {
                //"No subscriptions found for the given credentials"
                throw;
            }
        }

        [TestMethod]
        public async Task GetDefaultSubscription_And_TenantId_DidNotWork()
        {
            try
            {
                var creds = new DefaultAzureCredential();
                var armClient = new ArmClient(creds);
                var defSub = await armClient.GetDefaultSubscriptionAsync();
            }
            catch (Exception ex)
            {
                //Error:
                //"No subscriptions found for the given credentials"
                throw;
            }
        }

        [TestMethod]
        public async Task GetDefaultSubscription_And_TenantId_With_Options_DidNotWork()
        {
            try
            {
                var optios = new DefaultAzureCredentialOptions
                {
                    ExcludeAzureCliCredential = false
                };
                var creds = new DefaultAzureCredential(optios);
                var armClient = new ArmClient(creds);
                var defSub = await armClient.GetDefaultSubscriptionAsync();
            }
            catch (Exception ex)
            {
                //"No subscriptions found for the given credentials"
                throw;
            }
        }

        [TestMethod]
        public async Task GetSubscription()
        {
            try
            {
                //var client = new DefaultAzureCredential();
                //var ctx = new Azure.Core.TokenRequestContext(new string[] { "https://management.azure.com/.default" });
                var ctx = new Azure.Core.TokenRequestContext(new string[] { "https://management.core.windows.net/" });

                //var token = await client.GetTokenAsync(ctx);

                var defaultSubscription = "635a2074-cc31-43ac-bebe-2bcd67e1abfe";
                //var armClient = new ArmClient(new DefaultAzureCredential());
                var armClient = new ArmClient(new DefaultAzureCredential(), defaultSubscriptionId: defaultSubscription);
                var defSub = armClient.GetDefaultSubscription();
                //var defSub = await armClient.GetDefaultSubscriptionAsync(); //Error - No subscriptions found for the given credentials

                var subscriptions = armClient.GetSubscriptions(); //ToList comes up empty
                var s = subscriptions.ToList();

                //TODO Key vault works
                //TODO Test with SQL token
                //TODO Think about how will you structure the tests - what sample data do you need?
            }
            catch (Exception ex)
            {
                throw;
            }

            /*
The access token is from the wrong issuer 'https://sts.windows.net/f8cdef31-a31e-4b4a-93e4-5f571e91255a/'. It must match the tenant 'https://sts.windows.net/e66fc46b-2666-4ea3-984d-bb30c06f2c75/' associated with this subscription. Please use the authority (URL) 'https://login.windows.net/e66fc46b-2666-4ea3-984d-bb30c06f2c75' to get the token. Note, if the subscription is transferred to another tenant there is no impact to the services, but information about new tenant could take time to propagate (up to an hour). If you just transferred your subscription and see this error message, please try back later.
Status: 401 (Unauthorized)
ErrorCode: InvalidAuthenticationTokenTenant

Content:
{"error":{"code":"InvalidAuthenticationTokenTenant","message":"The access token is from the wrong issuer 'https://sts.windows.net/f8cdef31-a31e-4b4a-93e4-5f571e91255a/'. It must match the tenant 'https://sts.windows.net/e66fc46b-2666-4ea3-984d-bb30c06f2c75/' associated with this subscription. Please use the authority (URL) 'https://login.windows.net/e66fc46b-2666-4ea3-984d-bb30c06f2c75' to get the token. Note, if the subscription is transferred to another tenant there is no impact to the services, but information about new tenant could take time to propagate (up to an hour). If you just transferred your subscription and see this error message, please try back later."}}

Headers:
Cache-Control: no-cache
Pragma: no-cache
WWW-Authenticate: Bearer authorization_uri="https://login.windows.net/e66fc46b-2666-4ea3-984d-bb30c06f2c75", error="invalid_token", error_description="The access token is from the wrong issuer. It must match the tenant associated with this subscription. Please use correct authority to get the token."
x-ms-failure-cause: REDACTED
x-ms-request-id: 85890112-adf6-4cca-8991-f7a079c06a5b
x-ms-correlation-request-id: REDACTED
x-ms-routing-request-id: REDACTED
Strict-Transport-Security: REDACTED
X-Content-Type-Options: REDACTED
Date: Mon, 05 Sep 2022 21:59:35 GMT
Connection: close
Content-Type: application/json; charset=utf-8
Expires: -1
Content-Length: 677

             */
        }

        [TestMethod]
        public async Task GetTokenTest()
        {
            try
            {
                var creds = new DefaultAzureCredential();
                var scopes = new string[] { "https://management.core.windows.net/" };
                var tenantId = "e66fc46b-2666-4ea3-984d-bb30c06f2c75"; //The tenant id is important
                var ctx = new Azure.Core.TokenRequestContext(scopes: scopes, tenantId: tenantId);

                var token = await creds.GetTokenAsync(ctx);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        [TestMethod]
        public async Task TestMethod1()
        {
            try
            {
                var client = new DefaultAzureCredential();
                var ctx = new Azure.Core.TokenRequestContext(
                    new[] { "https://database.windows.net" });
                var token = await client.GetTokenAsync(ctx);

                //TODO Key vault works
                //TODO Test with SQL token
                //TODO Think about how will you structure the tests - what sample data do you need?
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        private async Task<string> GetAzureAccessToken()
        {
            var creds = new DefaultAzureCredential();
            var scopes = new string[] { "https://management.core.windows.net/" };
            var tenantId = "e66fc46b-2666-4ea3-984d-bb30c06f2c75"; //The tenant id is important
            var ctx = new Azure.Core.TokenRequestContext(scopes: scopes, tenantId: tenantId);

            var token = await creds.GetTokenAsync(ctx);
            return token.Token;
        }

        private async Task<string> GetDatabaseAccessToken()
        {
            var dbScope = "https://database.windows.net";

            var creds = new DefaultAzureCredential();
            var scopes = new string[] { dbScope };
            var tenantId = "e66fc46b-2666-4ea3-984d-bb30c06f2c75"; //The tenant id is important
            var ctx = new Azure.Core.TokenRequestContext(scopes: scopes, tenantId: tenantId);

            var token = await creds.GetTokenAsync(requestContext: ctx);
            return token.Token;
        }

        private async Task<string> GetDatabaseAccessTokenUsingAureCli()
        {
            var dbScope = "https://database.windows.net";

            var creds = new AzureCliCredential();
            var armClient = new ArmClient(creds); //Pass defaultSubscriptionId via environment
            var defSub = await armClient.GetDefaultSubscriptionAsync();

            var scopes = new string[] { dbScope };
            var tenantId = defSub.Data.TenantId.ToString();
            Trace.WriteLine($"Tenant id is {tenantId}");

            var ctx = new Azure.Core.TokenRequestContext(scopes: scopes, tenantId: tenantId);

            var token = await creds.GetTokenAsync(requestContext: ctx);
            return token.Token;
        }
    }
}