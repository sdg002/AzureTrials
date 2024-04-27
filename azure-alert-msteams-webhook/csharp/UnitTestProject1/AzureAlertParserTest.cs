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

            info.ContextProperties.Should().HaveCount(2);
            info.ContextProperties["teamswebhookurl"].Should().Be("http://myteams.channel.link/blah");
            info.ContextProperties["myprop2"].Should().Be("some value 2");
        }

        [TestMethod]
        public void When_Html()
        {
            var parser = new AzureAlertParser();
            var payload = new AlertInfo
            {
                Description="some description",
                Name="some name",
                CountOfAlerts=3,
                AlertEndTime = DateTime.UtcNow.AddMinutes(10),
                AlertStartTime = DateTime.UtcNow,
                AppInsightLink= "http://some.link/",
                TeamsWebHookEndPoint = "http://teams"
            };

            // Act
            var teamsPayload = parser.ConvertAlertToTeamsPayload(payload);

            // Assert
            teamsPayload.Text.Should().Contain(payload.Description);
            teamsPayload.Text.Should().Contain(payload.Name);
            teamsPayload.Text.Should().Contain(payload.CountOfAlerts.ToString());


        }

    }
}