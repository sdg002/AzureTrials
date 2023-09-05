// See https://aka.ms/new-console-template for more information
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.ApplicationInsights.WorkerService;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

//Refer https://learn.microsoft.com/en-us/azure/azure-monitor/app/ilogger?tabs=dotnet6#console-application
Console.WriteLine("Hello, World!");
using var channel = new InMemoryChannel();
IServiceCollection services = new ServiceCollection();

services.Configure<TelemetryConfiguration>(config => config.TelemetryChannel = channel);

services.AddLogging(builder =>
{
    // Only Application Insights is registered as a logger provider
    builder.AddApplicationInsights(
        configureTelemetryConfiguration: (config) => config.ConnectionString = System.Environment.GetEnvironmentVariable("APPLICATIONINSIGHTS_CONNECTION_STRING"),
        configureApplicationInsightsLoggerOptions: (options) => { }
    );
});

// Build ServiceProvider.
IServiceProvider serviceProvider = services.BuildServiceProvider();



// Obtain logger instance from DI.
ILogger<Program> logger = serviceProvider.GetRequiredService<ILogger<Program>>();

logger.LogInformation("This is an information item from the console logger");
logger.LogWarning("This is a warning item from the console logger");
logger.LogError(new DivideByZeroException(), "there was divide by zero error from the console exe");
channel.Flush();
Task.Delay(5000).Wait();
return;