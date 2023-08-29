using Microsoft.AspNetCore.Mvc;

namespace csharp_webapp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

        private readonly ILogger<WeatherForecastController> _logger;

        public WeatherForecastController(ILogger<WeatherForecastController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetWeatherForecast")]
        [Route("/GetWeatherForecast")]
        public IEnumerable<WeatherForecast> Get()
        {
            _logger.LogInformation("Inside method GetWeatherForecase (Information)");
            _logger.LogWarning("Inside method GetWeatherForecase (Warning)");
            return Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
                TemperatureC = Random.Shared.Next(-20, 55),
                Summary = Summaries[Random.Shared.Next(Summaries.Length)]
            })
            .ToArray();
        }

        [HttpGet(Name = "LogException")]
        [Route("/LogException")]
        public string GenerateException()
        {
            var now = DateTime.Now;
            var message = $"Going to generate an exception at {now}";
            try
            {
                _logger.LogInformation(message);
                int x = 0;
                var y = 1 / x;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception was logged at time:{now}", now);
            }
            return message;
        }
    }
}