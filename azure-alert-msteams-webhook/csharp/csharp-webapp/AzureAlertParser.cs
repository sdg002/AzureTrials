using System.Text;
using System.Text.Json.Nodes;

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
            var node=JsonObject.Parse(body);
            node = node ?? throw new InvalidOperationException($"Could not parse Alert JSON: {body}");
            return new AlertInfo
            {
                Name = node["data"]["essentials"]["alertRule"].ToString(),
                Description = node["data"]["essentials"]["description"].ToString(),
                AlertEndTime = node["data"]["alertContext"]["condition"]["windowEndTime"].GetValue<DateTime>(),
                AlertStartTime = node["data"]["alertContext"]["condition"]["windowStartTime"].GetValue<DateTime>(),
                CountOfAlerts = (int)node["data"]["alertContext"]["condition"]["allOf"][0]["metricValue"].GetValue<float>(),
                AppInsightLink = node["data"]["alertContext"]["condition"]["allOf"][0]["linkToFilteredSearchResultsUI"].ToString()
            };
        }
    }
}