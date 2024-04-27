using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using RouteAttribute = Microsoft.AspNetCore.Mvc.RouteAttribute;

namespace csharp_webapp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AzureAlertsWebHooksController : ControllerBase
    {
        private readonly ILogger<AzureAlertsWebHooksController> _logger;

        public AzureAlertsWebHooksController(ILogger<AzureAlertsWebHooksController> logger)
        {
            this._logger = logger;
        }

        [HttpGet]
        [HttpPost]
        [Route("CatchIncomingMessage")]
        public async Task<string> CatchIncomingMessage()
        {
            var body = await new StreamReader(this.Request.Body).ReadToEndAsync();
            _logger.LogInformation("Inside method {method}, {body}", nameof(CatchIncomingMessage), body);
            return body;
        }
        [HttpGet]
        [HttpPost]
        [Route("RelayIncomingMessage")]
        public async Task<string> RelayIncomingMessage()
        {
            var body = await new StreamReader(this.Request.Body).ReadToEndAsync();
            _logger.LogInformation("Inside method {method}, {body}", nameof(RelayIncomingMessage), body);
            var parser = new AzureAlertParser();
            AlertInfo alertInfo = null;
            TeamsWebHookPayload teamsPayload = null;
            try
            {
                alertInfo=parser.Parse(body);
                teamsPayload = parser.ConvertAlertToTeamsPayload(alertInfo);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while attempting to parse the Azure Alert JSON:{json}", body);
                teamsPayload = new TeamsWebHookPayload
                {
                    Text = $"Exception was raised while trying to process the Azure JSON:{body}, Exception:{ex.ToString()}"
                };
                throw;
            }
                        
            _logger.LogInformation("Inside method {method}, {body}", nameof(CatchIncomingMessage), body);
            if (!alertInfo.ContextProperties.ContainsKey(AzureAlertParser.MsteamsLinkPropertyName))
            {
                throw new InvalidOperationException($"The custom property {AzureAlertParser.MsteamsLinkPropertyName} was not found in the Azure alert payload: {body}");
            }
            var mslink = alertInfo.ContextProperties[AzureAlertParser.MsteamsLinkPropertyName];
                
            await RelayTextToTeams(mslink,teamsPayload);
            return body;
        }

        private async Task RelayTextToTeams(string channelEndPoint, TeamsWebHookPayload payload)
        {
            //TODO pass URL from Postman using sample payload
            _logger.LogInformation("Begin-Going to post the payload:{payload}", payload);
            var httpClient = new HttpClient();
            var sw = new Stopwatch();
            await httpClient.PostAsJsonAsync<TeamsWebHookPayload>(channelEndPoint,payload);
            _logger.LogInformation("End-Going to post the payload:{payload}, time:{elapsed}", payload, sw.ElapsedMilliseconds);
        }
    }

}
