using Microsoft.Extensions.Configuration;

namespace TestProject1
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestMethod1()
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
    }
}