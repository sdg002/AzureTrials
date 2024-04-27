using System.Text;
using System.Text.Json.Nodes;

namespace csharp_webapp
{
    public class AzureAlertParser
    {
        public const string MsteamsLinkPropertyName = "teamswebhookurl";
        public AzureAlertParser()
        {
        }

        public TeamsWebHookPayload ConvertAlertToTeamsPayload(AlertInfo alertInfo)
        {

            var sb = new StringBuilder();
            sb.Append($"<h1>{alertInfo.Description}</h1>");
            sb.Append("<br/>");
            sb.Append($"<strong>Name:</strong> {alertInfo.Name}");
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
            var info= new AlertInfo
            {
                Name = node["data"]["essentials"]["alertRule"].ToString(),
                Description = node["data"]["essentials"]["description"].ToString(),
                AlertEndTime = node["data"]["alertContext"]["condition"]["windowEndTime"].GetValue<DateTime>(),
                AlertStartTime = node["data"]["alertContext"]["condition"]["windowStartTime"].GetValue<DateTime>(),
                CountOfAlerts = (int)node["data"]["alertContext"]["condition"]["allOf"][0]["metricValue"].GetValue<float>(),
                AppInsightLink = node["data"]["alertContext"]["condition"]["allOf"][0]["linkToFilteredSearchResultsUI"].ToString()
            };

            var props = node["data"]["alertContext"]["properties"];

            var nameValues = ((System.Text.Json.Nodes.JsonObject)props)?.ToList();

            if (nameValues != null)
            {
                nameValues.ForEach(x => info.ContextProperties.Add(x.Key, x.Value?.ToString() ?? string.Empty));
            }
            


            /*
             * 
             you were here
            read the array belwo and convert to Dictionary
((System.Text.Json.Nodes.JsonObject)props).Count
2
((System.Text.Json.Nodes.JsonObject)props)[0]
'((System.Text.Json.Nodes.JsonObject)props)[0]' threw an exception of type 'System.InvalidOperationException'
    Data: {System.Collections.ListDictionaryInternal}
    HResult: -2146233079
    HelpLink: null
    InnerException: null
    Message: "The node must be of type 'JsonArray'."
    Source: "System.Text.Json"
    StackTrace: "   at System.Text.Json.Nodes.JsonNode.AsArray()\r\n   at System.Text.Json.Nodes.JsonNode.get_Item(Int32 index)"
    TargetSite: {System.Text.Json.Nodes.JsonArray AsArray()}
((System.Text.Json.Nodes.JsonObject)props).ToArray()
{System.Collections.Generic.KeyValuePair<string, System.Text.Json.Nodes.JsonNode>[2]}
    [0]: {[teamswebhookurl, "http://myteams.channel.link/blah"]}
    [1]: {[myprop2, "some value 2"]}
((System.Text.Json.Nodes.JsonObject)props).ToArray()[0]
{[teamswebhookurl, "http://myteams.channel.link/blah"]}
    Key: "teamswebhookurl"
    Value: "http://myteams.channel.link/blah"
((System.Text.Json.Nodes.JsonObject)props).ToArray()[0].Key
"teamswebhookurl"
((System.Text.Json.Nodes.JsonObject)props).ToArray()[0].Value
"http://myteams.channel.link/blah"
    Json: "\"http://myteams.channel.link/blah\""
    Path: "$.data.alertContext.properties.teamswebhookurl"
    Value: ValueKind = String : "http://myteams.channel.link/blah"
((System.Text.Json.Nodes.JsonObject)props).ToArray()[0].Value.ToString()
"http://myteams.channel.link/blah"
             
             */
            return info;
        }
    }
}