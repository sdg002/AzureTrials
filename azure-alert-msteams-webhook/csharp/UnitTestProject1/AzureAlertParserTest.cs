using csharp_webapp;
using FluentAssertions;

namespace UnitTestProject1
{
    [TestClass]
    public class AzureAlertParserTest
    {
        [TestMethod]
        public void When_Parse()
        {
            //Arrange
            var parser = new AzureAlertParser();
            var sampleAlertJson = System.IO.File.ReadAllText("data/azure.alert.3.error.json");

            //Act
            var info = parser.Parse(sampleAlertJson);

            //Assert
            info.Description.Should().Be("this is a hand crafter alert and action");
            info.Name.Should().Be("mysimplealertandaction");
            info.CountOfAlerts.Should().Be(2);
            info.AppInsightLink.Should().Be("https://linktoappinsight");

            info.AlertStartTime.Should().Be(DateTime.Parse("2023-08-30T07:20:59Z", null, System.Globalization.DateTimeStyles.AdjustToUniversal));
            info.AlertEndTime.Should().Be(DateTime.Parse("2023-08-30T07:25:59Z", null, System.Globalization.DateTimeStyles.AdjustToUniversal));
        }
    }
}