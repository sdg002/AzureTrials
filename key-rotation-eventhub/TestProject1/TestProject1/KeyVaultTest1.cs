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
    public class KeyVaultTest1
    {
        readonly static string _keyVaultName = "saudemovault456";
        readonly static string _kvUri = "https://" + _keyVaultName + ".vault.azure.net";

        [TestMethod]
        public async Task KeyVault_Using_SecretClient()
        {
            try
            {
                //
                //you were reading this https://learn.microsoft.com/en-us/azure/key-vault/secrets/quick-create-net?tabs=azure-cli
                //you were about to install the package Azure.Security.KeyVault.Secrets

                string keyVaultName = "saudemovault456";
                var kvUri = "https://" + keyVaultName + ".vault.azure.net";

                var options = new SecretClientOptions()
                {
                    Retry = 
                    {
                        Mode = Azure.Core.RetryMode.Exponential
                    }
                };
                var client = new Azure.Security.KeyVault.Secrets.SecretClient(new Uri(_kvUri), new DefaultAzureCredential(),options);

                var client = new Azure.Security.KeyVault.Secrets.SecretClient(new Uri(kvUri), new DefaultAzureCredential());


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
                    .AddAzureKeyVault(new Uri(_kvUri), new DefaultAzureCredential(), keyVaultConfigOptions)
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

        [Timeout(timeout:60000)]
        [TestMethod]
        public void KeyVault_ConfigurationBuilder_Refresh()
        {
            //You were here, do some key vault stuff

            try
            {
                //
                //you were reading this https://learn.microsoft.com/en-us/azure/key-vault/secrets/quick-create-net?tabs=azure-cli
                //you were about to install the package Azure.Security.KeyVault.Secrets

                const int RefreshSeconds = 30;
                var keyVaultConfigOptions = new Azure.Extensions.AspNetCore.Configuration.Secrets.AzureKeyVaultConfigurationOptions
                {
                    ReloadInterval = TimeSpan.FromSeconds(RefreshSeconds),
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


                var eventHub = configuration["eventhubcnstring"];
                var secretName = "eventhubcnstring";

                int counter = 0;
                while (true) 
                {
                    var secretValue = configuration[secretName];
                    Trace.WriteLine($"{DateTime.Now}:Value of secret:{secretName} is {secretValue}");
                    Trace.WriteLine($"Waiting....{counter}");
                    Thread.Sleep(5000);
                    counter++;
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}