using Microsoft.Extensions.Configuration;
using Azure.Identity;
using Microsoft.VisualStudio.TestPlatform.CommunicationUtilities;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;
using Azure.Security.KeyVault.Secrets;
using System.Net.Sockets;

namespace TestProject1
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void InMemoryConfiguration()
        {
            //You were here, do some key vault stuff

            try
            {
                var configuration = new ConfigurationBuilder()
                    .AddInMemoryCollection(new Dictionary<string, string?>()
                    {
                        ["SomeKey"] = "SomeValue"
                    })
                    .Build();

                Assert.AreEqual<string>("SomeValue", configuration!["SomeKey"]);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        [TestMethod]
        public async Task KeyVault_SecretClient()
        {
            try
            {

                string keyVaultName = "saudemovault456";
                var kvUri = "https://" + keyVaultName + ".vault.azure.net";

                var options = new SecretClientOptions()
                {
                    Retry = 
                    {
                        Mode = Azure.Core.RetryMode.Exponential
                    }
                };
                var client = new Azure.Security.KeyVault.Secrets.SecretClient(new Uri(kvUri), new DefaultAzureCredential(),options);


                var secretName = "eventhubcnstring";
                var secret=await client.GetSecretAsync(secretName);
                Trace.WriteLine($"Value of secret:{secretName} is {secret.Value.Value}");

                
            }
            catch (Exception ex)
            {
                throw;
            }

        }
        [TestMethod]
        public void KeyVault_ConfigurationBuilder()
        {
            //You were here, do some key vault stuff

            try
            {
                //
                //you were reading this https://learn.microsoft.com/en-us/azure/key-vault/secrets/quick-create-net?tabs=azure-cli
                //you were about to install the package Azure.Security.KeyVault.Secrets

                var keyVaultConfigOptions = new Azure.Extensions.AspNetCore.Configuration.Secrets.AzureKeyVaultConfigurationOptions
                {
                    ReloadInterval = TimeSpan.FromSeconds(30),
                };
                //var secretClient = new KeyVaultClient(new Defau)
                string keyVaultName = "saudemovault456";
                var kvUri = "https://" + keyVaultName + ".vault.azure.net";

                //var client = new Azure.Security.KeyVault.Secrets.SecretClient(new Uri(kvUri), new DefaultAzureCredential());

                var configuration = new ConfigurationBuilder()
                    .AddInMemoryCollection(new Dictionary<string, string?>()
                    {
                        ["SomeKey"] = "SomeValue"
                    })
                    .AddAzureKeyVault(new Uri(kvUri), new DefaultAzureCredential(), keyVaultConfigOptions)
                    .Build();

                Assert.AreEqual<string>("SomeValue", configuration!["SomeKey"]);

                var eventHub = configuration["eventhubcnstring"];
                var secretName = "eventhubcnstring";
                var secretValue = configuration[secretName];
                Trace.WriteLine($"Value of secret:{secretName} is {secretValue}");
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}