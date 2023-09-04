// See https://aka.ms/new-console-template for more information
using Microsoft.ApplicationInsights.WorkerService;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

Console.WriteLine("Hello, World!");
IServiceCollection services = new ServiceCollection();

// Being a regular console app, there is no appsettings.json or configuration providers enabled by default.
// Hence instrumentation key/ connection string and any changes to default logging level must be specified here.
services.AddLogging(loggingBuilder => loggingBuilder.AddFilter<Microsoft.Extensions.Logging.ApplicationInsights.ApplicationInsightsLoggerProvider>("Category", LogLevel.Information));
services.AddApplicationInsightsTelemetryWorkerService((ApplicationInsightsServiceOptions options) =>
{
    options.InstrumentationKey = System.Environment.GetEnvironmentVariable("APPLICATIONINSIGHTS_CONNECTION_STRING");
    Console.WriteLine($"Going to use the instrumentation key {options?.InstrumentationKey}");
});

// To pass a connection string
// - aiserviceoptions must be created
// - set connectionstring on it
// - pass it to AddApplicationInsightsTelemetryWorkerService()

// Build ServiceProvider.
IServiceProvider serviceProvider = services.BuildServiceProvider();

// Obtain logger instance from DI.
ILogger<Program> logger = serviceProvider.GetRequiredService<ILogger<Program>>();

logger.LogInformation("This is an information item from the console logger");
logger.LogWarning("This is a warning item from the console logger");
logger.LogError(new DivideByZeroException(), "there was divide by zero error from the console exe");
return;