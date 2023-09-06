using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

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

    }

}
