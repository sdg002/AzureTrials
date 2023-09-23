using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestProject1
{
    [TestClass]
    public class BasicConfigurationBuilderDemoTests
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
        public void EnvironmentConfiguration()
        {
            //You were here, do some key vault stuff

            try
            {
                var configuration = new ConfigurationBuilder()
                    .AddEnvironmentVariables()
                    .AddInMemoryCollection(new Dictionary<string, string?>()
                    {
                        ["SomeKey"] = "SomeValue"
                    })
                    .Build();

                Assert.AreEqual<string>("SomeValue", configuration!["SomeKey"]);

                Assert.AreEqual<string>("C:", configuration!["SYSTEMDRIVE"]);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

    }
}
