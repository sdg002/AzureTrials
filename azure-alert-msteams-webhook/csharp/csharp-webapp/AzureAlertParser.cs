using System.Text;

namespace csharp_webapp
{
    public class AzureAlertParser
    {
        public AzureAlertParser()
        {
        }

        public TeamsWebHookPayload ConvertAlertToTeamsPayload(AlertInfo alertInfo)
        {
            var sb = new StringBuilder();
            sb.Append($"<h1>{alertInfo.Name}</h1>");
            sb.Append("<br/>");
            sb.Append($"<strong>Start time:</strong> {alertInfo.AlertStartTime}");
            sb.Append("<br/>");
            sb.Append($"<strong>End time:</strong> {alertInfo.AlertEndTime}");
            sb.Append("<br/>");
            sb.Append($"<strong>Count of alerts:</strong> {alertInfo.CountOfAlerts}");
            sb.Append("<br/>");
            sb.Append($"<strong>Link to the Application Insights:</strong> <a href='{alertInfo.AppInsightLink}'>Click here</a>");
            sb.Append("<br/>");
            return new TeamsWebHookPayload
            {
                Text = sb.ToString(),
            };
        }

        public AlertInfo Parse(string body)
        {
            return new AlertInfo
            {
                Name = "Hello world alerts",
                AlertEndTime = DateTime.Now.AddMinutes(-30),
                AlertStartTime = DateTime.Now,
                CountOfAlerts = 5,
                AppInsightLink = "http://www.bing.com/"
            };
        }
    }
}