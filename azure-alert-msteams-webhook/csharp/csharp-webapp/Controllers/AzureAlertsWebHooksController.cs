﻿using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
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
            _logger.LogInformation("Inside method {method}, {body}", nameof(CatchIncomingMessage), body);
            var mslink = "https://petroineos.webhook.office.com/webhookb2/27a85953-b219-48a9-8381-10515a7df0fd@65795a07-17bb-4e5a-a1fa-1c3d63e0a4fd/IncomingWebhook/7c76e7ba05c24cdc8b301f46772af8ea/61665664-9bff-4859-bd66-55797f42dada";
            await RelayTextToTeams(mslink,$"hello world {DateTime.Now}");
            return body;
        }

        private async Task RelayTextToTeams(string channelEndPoint, string text)
        {
            //you were here, call a get use hard coded url
            //then get the JSON and get url
            //pass URL from Postman using sample payload
            var payload = new { text = text };
            var jsonPayload = JsonSerializer.Serialize(payload);
            var httpClient = new HttpClient();
            await httpClient.PostAsync(channelEndPoint, new StringContent(jsonPayload));
        }
    }

}
