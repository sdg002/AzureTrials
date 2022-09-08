using Azure.Identity;
using Azure.ResourceManager;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.Threading.Tasks;

namespace IntegrationTests
{
    public class AzureHelper
    {
        internal async Task<string> GetDatabaseAccessToken()
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

        internal Task<string> GetServerlessEndPoint()
        {
            string server = "testsynapse-dev-ondemand.sql.azuresynapse.net";
            return Task.FromResult(server);
        }
    }
}