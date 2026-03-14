---
layout: default
title: Programmatic MCP Demo
---

<script>
(function() {
  var s = document.createElement('script');
  s.src = '/assets/js/mermaid.min.js';
  s.onload = function() {
    mermaid.initialize({ startOnLoad: false, securityLevel: 'loose' });
    mermaid.run();
  };
  document.head.appendChild(s);
})();
</script>

# Programmatic MCP Demo


### MCP Architecture — Systems View

MCP is a standardized interface that enables AI applications to interact with a wide variety of data sources and tools in a consistent way. The architecture can be visualized as a layered graph, where the middle layer is the MCP protocol, connecting AI applications on one side and data sources/tools on the other.

<div class="mermaid" markdown="0">
%%{init: {'theme': 'base', 'themeVariables': {'fontSize': '16px'}}}%%
graph TD
    subgraph AI_Applications ["AI Applications & Interfaces"]
        direction TB
        A1["<b>Chat Interfaces</b><br/>(Windows Copilot, ChatGPT, Claude)"]
        A2["<b>IDEs & Code Editors</b><br/>(VS Code, Visual Studio, Cursor)"]
        A3["<b>Custom .NET AI Apps</b><br/>(Semantic Kernel, .NET SDKs)"]
    end

    subgraph Protocol_Layer ["Model Context Protocol — Middle Layer"]
        MCP["<b>● Model Context Protocol ●</b><br/>(Standardized Interface)"]
    end

    subgraph Data_Tools ["Data Sources & Tools"]
        direction TB
        D1["<b>File System</b><br/>(Windows File I/O, UNC Shares, OneDrive)"]
        D2["<b>Databases</b><br/>(SQL Server, Azure SQL, SQLite)"]
        D3["<b>Microsoft Cloud APIs</b><br/>(MS Graph, SharePoint, Azure Blob Storage)"]
        D4["<b>REST & Web APIs</b><br/>(GitHub, OpenWeather, Custom HTTP Services)"]
        D5["<b>Windows System APIs</b><br/>(WMI, Registry, Event Log, PowerShell)"]
    end

    AI_Applications <==> MCP
    MCP <==> Data_Tools

    style MCP fill:#00FF00,stroke:#333,stroke-width:4px
    style AI_Applications fill:#e1f5fe,stroke:#01579b
    style Data_Tools fill:#fff3e0,stroke:#e65100
</div>

---

## Key-takeaway : MCP is also both a contract and a protocol

It is important to limit of what a LLM can reach and define a contract that defines which tools, (data) resources and other capabilities that a LLM can access. 

MCP is both a protocol and contract that defines how AI applications can request and receive data from various sources. It abstracts away the complexities of different APIs and data formats, allowing developers to focus on building AI applications without worrying about the underlying data access.


## The MCP Demo : Yr weather service using Model Context Protcol 

The demo is a simple weather service that uses Yr web services to provide weather information. 

**What we will build**

The demo is a web application where you can ask about the weather at a given place and get the response which will use a tool that uses Yr web services to get weather information. The demo demonstrates using MCP tools. **Tools** is a category of capabilities that are offered in the MCP protocol.

Server features that are offered with MCP are : 
* Tools : Executable functions that allow models to perform actions or retrieve information 
* Resources : Structured data or content that provides additional context to the model 
* Prompts : Predefined templates or instructions that guide language model interactions

The screenshot below shows the Demo in action, where I ask abou thte weather in Trondheim tonight. I specify it to include deatils also. 

As we see, we can ask where free-form about the weather the AI LLM model which makes it possible to have a more natural converation about the weather than just using a website to look up the weather. 

Example of a more advanced demo would be :
We could have combined this for example with Synthesized Text to Speech voice assistant and Speec to Text to have a natural conversation with the AI model.

### Screenshot of the demo 

![claude](../assets/images/lecture1/claudechatdemo2.png)

The demo here focuses on *Tools*. 

Yr is a popular weather service in Norway delievered by Norwegian Metereological Institute (met.no) in Oslo, Norway. 

In the same demo repo, you find code how you can expose metadat about the tools the MCP offers. 

We can with for example Swagger present metadata information about the tools that are offered in the MCP protocol. This is a good way to present the contract of the MCP protocol and what capabilities it offers.

![Swagger tools Json RPC](../assets/images/lecture1/toolsmetadatajsonrpcmcpdemo1.png)

### Github repo for the MCP Weather Demo
The Github repo is public available here for those who want to explore the code and try it out themselves : 

https://github.com/toreaurstadboss/WeatherMCPDemo

Note that to run the demo, you must have an account at Anthropic web site and set up an API key here:

https://console.anthropic.com/dashboard

To just test out Anthropic, it is not expensive. I paid them 20 dollars a year ago and still have about 5 dollars left on the account of mine. And this includes a lot of testing and playing around using the Anthropic Claude service.

The model I have been using while testing is _claude-3-haiku-20240307_ , it is some months since I worke dwith the demo and therefore **newer Claude** models should be possible to test out here. 

### Serverside of the MCP Demo - WeatherServer.Web.Http 

First off, I have used the following Nuget's. It probably are some newer versions of these packages, they worked with .NET 10 Target framework when I tested it out. 


**WeatherServer.Web.Http.csproj Nuget packages :**
```xml

<ItemGroup>
	<PackageReference Include="ModelContextProtocol.AspNetCore" Version="0.3.0-preview.2" />
	<PackageReference Include="Swashbuckle.AspNetCore" Version="10.1.5" />
	<PackageReference Include="Swashbuckle.AspNetCore.SwaggerUI" Version="10.1.5" />
	<PackageReference Include="ModelContextProtocol" Version="0.3.0-preview.2" />
	<PackageReference Include="Anthropic.SDK" Version="5.5.1" />
	<PackageReference Include="Microsoft.Extensions.AI" Version="10.4.0" />
</ItemGroup>

```

The packags used here are covering different aspects of the MCP protocol and the implementation of the demo.

- Anthropic.SDK and ModelContextProtocol are the main packages that are used to implement the MCP protocol and to interact with the Anthropic Claude models.

- The ModelContextProtocol.AspNetCore package is used to set up the MCP protocol in an ASP.NET Core web application.

- Microsoft.Extensions.AI is used to integrate AI capabilities into the application, allowing us to easily call the Anthropic API and use the Claude models.

- Swashbuckle.AspNetCore and Swashbuckle.AspNetCore.SwaggerUI are used to set up Swagger UI for the application, which allows us to visualize the tools and resources that are offered in the MCP protocol.

**Program.cs**

First off, we add Mcp support using _AddMcpServer()_ on *builder.Services* and then we add the tools we have made and want to expose through the MCP protocol.

We will add three tools in the demo as shown below.

```csharp

 public static void Main(string[] args)
 {
     var builder = WebApplication.CreateBuilder(args);

     // Add MCP support
     builder.Services
         .AddMcpServer()
         .WithHttpTransport()
         .WithTools<YrTools>()
         .WithTools<UnitedStatesWeatherTools>()
         .WithTools<NominatimTools>();

```
Note that assembly scanning is supported, we could have used : 

_.WithToolsFromAssembly()_ to add ALL MCP tools in an assembly (project). 

I wanted also to be able to run the Server side using Swagger and chat with the Server itself, so a client for the server is actually also set up here. 

In addition to support HTTPS traffic as required for _SSE_ I set up a Powershell script in the repo to create a self-signed certificate and set up Kestrel to use it. Please note that the demo works best using Firefox browser as self-signed certificates become a bit tricky to do right in Chrome and Edge.. 

### Misc setup for serverside to support HTTPS self signed cert and MCP client

```csharp

    builder.Services.Configure<McpClientOptions>(options =>
    {
        builder.Configuration.GetSection("McpClient");
    });

    // Setup SSL certificate (optional)
    var subjectName = builder.Configuration["McpServer:CertificateSettings:SubjectName"];

    var portnumberMcp = builder.Configuration.GetValue("McpServer:Port", 7145);

    // Only force a specific certificate if SubjectName is configured.
    // Otherwise, let ASP.NET Core use the standard development certificate.
    if (!string.IsNullOrWhiteSpace(subjectName))
    {
        builder.WebHost.ConfigureKestrel(options =>
        {
            options.ListenLocalhost(portnumberMcp, listenOptions =>
            {
                using var store = new X509Store(StoreName.My, StoreLocation.LocalMachine);
                store.Open(OpenFlags.ReadOnly);

                var certs = store.Certificates.Find(
                    X509FindType.FindBySubjectName,
                    subjectName,
                    validOnly: false);

                var certificate = certs.FirstOrDefault();
                if (certificate == null)
                {
                    throw new InvalidOperationException($"Certificate not found in LocalMachine\\My. SubjectName='{subjectName}'.");
                }

                listenOptions.UseHttps(certificate);
            });
        });
    }

    var mcpEndpoint = builder.Configuration.GetSection("McpClient:Endpoint").Value;

    builder.Services.AddSingleton<IMcpClient>(_ =>
    {
        return McpClientFactory.CreateAsync(
            new SseClientTransport(
                new SseClientTransportOptions
                {
                    Endpoint = new Uri(mcpEndpoint!)
                }
            )).GetAwaiter().GetResult();
    });

    builder.Services.Configure<ModelContextProtocol.Protocol.Implementation>(options =>
    {
        options.Title = "WeatherMcpDemoServer";
        options.Version = "1.1";
    });

```

We also do more setup with the chat client here, passing in the ANTHROPIC_API_KEY from environment variable and seting up the model to use for chat completions 

``` csharp

  // Set up Anthropic client
  builder.Services.AddChatClient(_ =>
      new ChatClientBuilder(new AnthropicClient(new APIAuthentication(builder.Configuration["ANTHROPIC_API_KEY"])).Messages)
          .UseFunctionInvocation()
          .Build());

  // ..

     app.MapMcp("/sse"); // SSE endpoint at /sse

```

The entire Program.cs then looks like this : 

- Note that we create named http client to contact the api tools. This is done as the APIs the tools are contacting requries the client to set up a specific User Agent with a product name. 
- There has been some trial and error to make this work in a web setup over HTTPS. Trying out MCP first using STDIO (console) client and server is much easier and it is recommended to try that route out first. The demo of mine also got a console server and client project.

#### Program.cs 


```csharp

using Anthropic.SDK;
using Microsoft.Extensions.AI;
using ModelContextProtocol.Client;
using System.Net.Http.Headers;
using System.Security.Cryptography.X509Certificates;
using WeatherServer.Common;
using WeatherServer.Tools;

namespace WeatherServer.Http
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add MCP support
            builder.Services
                .AddMcpServer()
                .WithHttpTransport()
                .WithTools<YrTools>()
                .WithTools<UnitedStatesWeatherTools>()
                .WithTools<NominatimTols>();

            builder.Services.Configure<McpClientOptions>(options =>
            {
                builder.Configuration.GetSection("McpClient");
            });

            // Setup SSL certificate (optional)
            var subjectName = builder.Configuration["McpServer:CertificateSettings:SubjectName"];

            var portnumberMcp = builder.Configuration.GetValue("McpServer:Port", 7145);

            // Only force a specific certificate if SubjectName is configured.
            // Otherwise, let ASP.NET Core use the standard development certificate.
            if (!string.IsNullOrWhiteSpace(subjectName))
            {
                builder.WebHost.ConfigureKestrel(options =>
                {
                    options.ListenLocalhost(portnumberMcp, listenOptions =>
                    {
                        using var store = new X509Store(StoreName.My, StoreLocation.LocalMachine);
                        store.Open(OpenFlags.ReadOnly);

                        var certs = store.Certificates.Find(
                            X509FindType.FindBySubjectName,
                            subjectName,
                            validOnly: false);

                        var certificate = certs.FirstOrDefault();
                        if (certificate == null)
                        {
                            throw new InvalidOperationException($"Certificate not found in LocalMachine\\My. SubjectName='{subjectName}'.");
                        }

                        listenOptions.UseHttps(certificate);
                    });
                });
            }

            var mcpEndpoint = builder.Configuration.GetSection("McpClient:Endpoint").Value;

            builder.Services.AddSingleton<IMcpClient>(_ =>
            {
                return McpClientFactory.CreateAsync(
                    new SseClientTransport(
                        new SseClientTransportOptions
                        {
                            Endpoint = new Uri(mcpEndpoint!)
                        }
                    )).GetAwaiter().GetResult();
            });

            builder.Services.Configure<ModelContextProtocol.Protocol.Implementation>(options =>
            {
                options.Title = "WeatherMcpDemoServer";
                options.Version = "1.1";
            });

            // Add swagger support
            builder.Services.AddControllers();
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            // Configure logging
            builder.Logging.ClearProviders();
            builder.Logging.AddConsole(options =>
            {
                options.LogToStandardErrorThreshold = LogLevel.Warning;
            });
            builder.Logging.SetMinimumLevel(LogLevel.Debug);

            // Add named Http clients that fetches more data from external APIs
            builder.Services.AddHttpClient(WeatherServerApiClientNames.WeatherGovApiClientName, client =>
            {
                client.BaseAddress = new Uri("https://api.weather.gov");
                client.DefaultRequestHeaders.UserAgent.Add(new ProductInfoHeaderValue("us-weather-democlient2-tool", "1.0"));
            });

            builder.Services.AddHttpClient(WeatherServerApiClientNames.YrApiClientName, client =>
            {
                client.BaseAddress = new Uri("https://api.met.no");
                client.DefaultRequestHeaders.UserAgent.Clear();
                client.DefaultRequestHeaders.UserAgent.Add(new ProductInfoHeaderValue("yrweather-mcpdemoclient2-tore-tool", "1.0"));
            });

            builder.Services.AddHttpClient(WeatherServerApiClientNames.OpenStreetmapApiClientName, client =>
            {
                client.BaseAddress = new Uri("https://nominatim.openstreetmap.org");
                client.DefaultRequestHeaders.UserAgent.Clear();
                client.DefaultRequestHeaders.UserAgent.Add(new ProductInfoHeaderValue("nominatim-openstreetmap-client2-api-tool", "1.0"));
            });

            // Set up Anthropic client
            builder.Services.AddChatClient(_ =>
                new ChatClientBuilder(new AnthropicClient(new APIAuthentication(builder.Configuration["ANTHROPIC_API_KEY"])).Messages)
                    .UseFunctionInvocation()
                    .Build());

            var app = builder.Build();

            app.UseHttpsRedirection();
            app.UseAuthorization();

            app.MapControllers();

            app.UseSwagger();
            app.UseSwaggerUI();

            app.MapMcp("/sse"); // SSE endpoint at /sse

            app.Run();
        }
    }
}

```

We look at the two tools made for **Nominatim** and **Yr** APIs , the following two HTTP clients are made :


```csharp

 builder.Services.AddHttpClient(WeatherServerApiClientNames.YrApiClientName, client =>
 {
     client.BaseAddress = new Uri("https://api.met.no");
     client.DefaultRequestHeaders.UserAgent.Clear();
     client.DefaultRequestHeaders.UserAgent.Add(new ProductInfoHeaderValue("yrweather-mcpdemoclient2-tore-tool", "1.0"));
 });

 builder.Services.AddHttpClient(WeatherServerApiClientNames.OpenStreetmapApiClientName, client =>
 {
     client.BaseAddress = new Uri("https://nominatim.openstreetmap.org");
     client.DefaultRequestHeaders.UserAgent.Clear();
     client.DefaultRequestHeaders.UserAgent.Add(new ProductInfoHeaderValue("nominatim-openstreetmap-client2-api-tool", "1.0"));
 });

```

It is time to look at the tools themselves next that we defined in the Program.cs 

### NominatimTool 
- Note that tool method must be static an inside sealed class. This is a requirement for the MCP protocol and how the MCP server discovers and registers tools.
Looking up latitude and longitude from a geographical place is done with the tools presented below. The tool is using the Nominatim API from OpenStreetMap to look up the latitude and longitude of a given place.

- Please observe that the tool defined one parameter, which the place to look up. The parameter is decorated with a Description attribute, this is used to generate metadata about the tool and its parameters which can be used by clients to understand how to use the tool. This is part of the contract of the MCP protocol.
- The tool is defined inside a sealed class that is decorated with the [McpServerToolType] attribute, this is used to register the tool with the MCP server and to generate metadata about the tool type. 

```csharp

namespace WeatherServer.Tools;

using ModelContextProtocol.Server;
using System.ComponentModel;
using WeatherServer.Common;

[McpServerToolType]
public sealed class NominatimTols
{

    public string ToolId => "OpenStreetMap Nominatim tool";

    [McpServerTool(Name = "NominatimLookupLatLongForPlace"), Description("Get latitude and longitude for a place using Nominatim service of OpenStreetMap.")]
    public static async Task<string> GetLatitudeAndLongitude(
        IHttpClientFactory clientFactory,
        [Description("The place to get latitude and longitude for. Will use Nominatim service of OpenStreetMap")] string place)
    {
        var client = clientFactory.CreateClient(WeatherServerApiClientNames.OpenStreetmapApiClientName);

        using var jsonDocument = await client.ReadJsonDocumentAsync($"/search?q={Uri.EscapeDataString(place)}&format=geojson&limit=1");
        var features = jsonDocument.RootElement.GetProperty("features").EnumerateArray();

        if (!features.Any())
        {
            return $"No location data found for '{place}'. Try another place to query?";
        }

        var feature = features.First();

        var geometry = feature.GetProperty("geometry");

        var geometryType = geometry.GetProperty("type").GetString();

        if (string.Equals(geometryType, "point", StringComparison.OrdinalIgnoreCase))
        {
            var pointCoordinates = geometry.GetProperty("coordinates").EnumerateArray();
            if (pointCoordinates.Any())
            {
                return $"Latitude: {pointCoordinates.ElementAt(1)}, Longitude: {pointCoordinates.ElementAt(0)}";
            }
        }

        return $"No location data found for '{place}'. Try another place to query?";
    }

}


```

We use *IHttpClientFactory* to create the http client that will use the right setup for accessing the Nominatim API. The client was defined inside the `Program.cs` shown above.

Observe the use of Name and Description here. Here we provide both the metadata and the description that will be used by clients and the MCP protocol to understand how to use and limit usage of the tool. 

The tool is inside an asynchronous method and returns a string with the latitude and longitude of the placed looked up, if found.

Let's next look at the other tool, the one that uses the Yr API to look up weather information. 

## YrTool 

The yr tool is defined in the same way as the Nominatim tool, it is a sealed class decorated with the [McpServerToolType] attribute and it defines one method that is decorated with the [McpServerTool] attribute. The method takes in a place and a time and returns a string with the weather information for that place and time.

The tools has got an instruction in the Description that tells the tool to use the Nominatim tool to look up coordinates for the place that is to be checked for weather prediction. 

Also note the other detailed instructions given here. We again
decorate the class with [McpServerToolType] attribute an [McpServerTool] for the method itself. 

We also use async here since we communicate with the remote service.

```csharp 

namespace WeatherServer.Tools;

using Microsoft.Extensions.Logging;
using ModelContextProtocol.Server;
using System;
using System.ComponentModel;
using System.Globalization;
using System.Text;
using System.Text.Json;
using WeatherServer.Common;
using WeatherServer.Models;

[McpServerToolType]
public sealed class YrTools
{
    public string ToolId => "Yr tool";

    [McpServerTool(Name = "YrWeatherCurrentWeather")]
    [Description(
 $@"""
     Description of this tool method:
     Retrieves the current weather conditions for a specified location using the YrTools CurrentWeather API.

    Usage Instructions:
    1. Use the 'NominatimLookupLatLongForPlace' tool to resolve the latitude and longitude of the provided location.
    2. Pass the resolved coordinates from the tool above and pass them into to this method.
    3. If coordinates cannot be resolved, use latitude = 0 and longitude = 0. In this case, the method will return a message indicating no results were found.
    4. In case the place passed in is for a place in United States, use instead the tool 'UsWeatherForecastLocation'.
    5. This method is to be used when asked about the current weather right now. 
    6. Use the system clock to check the date of today.

    Response Requirements:
    - It is very important that the corret url is used, longitude and latitude here will be provided . $""weatherapi/locationforecast/2.0/compact?lat={{latitude}}&lon={{longitude}}""
    - Always include the latitude and longitude used.
    - Always inform about which url was used to get the data here.
    - Inform about the time when the weather is.
    - Always include the 'time' field from the result to indicate when the weather data is valid.
    - Clearly state that the data was retrieved using 'YrWeatherCurrentWeather'.
    - Do not modify or reformat the result; return it exactly as received.
    - Do not show the data in Json format, instead sum it up using a dashed list.
    - Inform the time the weather is for
    - Append the raw json data also
    - If the weather time has passed current time by say two days, inform that you could not retrieve weather conditions for now. Look at the 'time' value you got and compare it with today. This is probably due to API usage conditions are limits the service.
""")]
    public static async Task<string> GetCurrentWeatherForecast(
        IHttpClientFactory clientFactory,
        ILogger<YrTools> logger,
        [Description("Provide current weather. State the location, latitude and longitude used. Return precisely the data given. Return ALL the data you were given.")] string location, decimal latitude, decimal longitude)
    {
        if (latitude == 0 && longitude == 0)
        {
            return $"No current weather data found for '{location}'. Try another location to query?";
        }



        var client = clientFactory.CreateClient(WeatherServerApiClientNames.YrApiClientName);

        string url = $"weatherapi/locationforecast/2.0/compact?lat={latitude.ToString(CultureInfo.InvariantCulture)}&lon={longitude.ToString(CultureInfo.InvariantCulture)}";

        logger.LogWarning($"Accessing Yr Current Weather with url: {url} with client base address {client.BaseAddress}");

        using var jsonDocument = await client.ReadJsonDocumentAsync(url);
        var timeseries = jsonDocument.RootElement.GetProperty("properties").GetProperty("timeseries").EnumerateArray();

        if (!timeseries.Any())
        {
            return $"No current weather data found for '{location}'. Try another place to query?";
        }

        var currentWeatherInfos = GetInformationForTimeSeries(timeseries, onlyFirst: true);

        var sb = new StringBuilder();
        foreach (var info in currentWeatherInfos)
        {
            sb.AppendLine(info.ToString());
        }

        return sb.ToString();
    }

    [McpServerTool(Name = "YrWeatherTenDayForecast")]
    [Description(
$@"""
     Description of this tool method:
     Retrieves the ten days forecast weather for a specified location using the YrTools Forecast API.

    Usage Instructions:
    1. Use the 'NominatimLookupLatLongForPlace' tool to resolve the latitude and longitude of the provided location.
    2. Pass the resolved coordinates from the tool above and pass them into to this method.
    3. If coordinates cannot be resolved, use latitude = 0 and longitude = 0. In this case, the method will return a message indicating no results were found.
    4. In case the place passed in is for a place in United States, use instead the tool 'UsWeatherForecastLocation'.
    5. Usually, only ten days forecast will be available, but output all data you get here. In case you are asked to provide even further into the future weather information and
    there are no available data for that, inform about that in the output.
    6. In case asked for a forecast weather, use this method. In case asked about current weather, use instead tool 'YrWeatherCurrentWeather'
    7. Check the current day with the system clock. Forecast should be the following days from the current day.

    Response Requirements:
    - It is very important that the correct url is used, longitude and latitude here will be provided . $""weatherapi/locationforecast/2.0/compact?lat={{latitude}}&lon={{longitude}}""
    - Always include the latitude and longitude used.
    - Always include the 'time' field from the result to indicate when the weather data is valid.
    - Clearly state that the data was retrieved using 'YrWeatherTenDayForecast'.
    - Any information about the weather must precisely give the scalar values provided. However, you are allowed to do a qualitative summary of the weather in 4-5 sentences first. Also,
      the time series is a bit long for a possible 10 day forecast hour by hour. Therefore sum up the trends such as maximum and minimum temperature and precipitation and wind patterns in the summary.
      Plus also give some precise examples of the weather.
    - Inform about the start and end time of the forecast. In case asked for forecast further into the future and there is no data available, inform that only data is available 
      until the given end time.
    - If the weather time has passed current time by say two days, inform that you could not retrieve weather conditions for now. Look at the 'time' value you got and compare it with today. This is probably due to API usage conditions are limits the service.
""")]
    public static async Task<string> GetTenDaysWeatherForecast(
     IHttpClientFactory clientFactory,
     ILogger<YrTools> logger,
     [Description("Provide ten day forecast weather. State the location, latitude and longitude used. Return the data given. Return ALL the data you were given.")] string location, decimal latitude, decimal longitude)
    {
        if (latitude == 0 && longitude == 0)
        {
            return $"No current weather data found for '{location}'. Try another location to query?";
        }

        var client = clientFactory.CreateClient(WeatherServerApiClientNames.YrApiClientName);

        var url = $"/weatherapi/locationforecast/2.0/compact?lat={latitude.ToString(CultureInfo.InvariantCulture)}&lon={longitude.ToString(CultureInfo.InvariantCulture)}";

        logger.LogWarning($"Accessing Yr Current Weather with url: {url} with client base address {client.BaseAddress}");

        using var jsonDocument = await client.ReadJsonDocumentAsync(url);
        var timeseries = jsonDocument.RootElement.GetProperty("properties").GetProperty("timeseries").EnumerateArray();

        if (!timeseries.Any())
        {
            return $"No current weather data found for '{location}'. Try another place to query?";
        }

        var currentWeatherInfos = GetInformationForTimeSeries(timeseries, onlyFirst: false);

        var sb = new StringBuilder();
        foreach (var info in currentWeatherInfos)
        {
            sb.AppendLine(info.ToString());
        }

        return sb.ToString();
    }

    private static List<YrWeatherInfoItem> GetInformationForTimeSeries(JsonElement.ArrayEnumerator timeseries, bool onlyFirst)
    {
        var result = new List<YrWeatherInfoItem>();

        foreach (var timeseriesItem in timeseries)
        {
            var currentWeather = timeseriesItem;
            var currentWeatherData = currentWeather.GetProperty("data");
            var instant = currentWeatherData.GetProperty("instant");
            string? nextOneHourWeatherSymbol = null;
            double? nextOneHourPrecipitationAmount = null;
            if (currentWeatherData.TryGetProperty("next_1_hours", out JsonElement nextOneHours))
            {
                nextOneHourWeatherSymbol = nextOneHours.GetProperty("summary").GetProperty("symbol_code").GetString();
                nextOneHourPrecipitationAmount = nextOneHours.GetProperty("details").GetProperty("precipitation_amount").GetDouble();
            }

            string? nextSixHourWeatherSymbol = null;
            double? nextSixHourPrecipitationAmount = null;
            if (currentWeatherData.TryGetProperty("next_6_hours", out JsonElement nextSixHours))
            {
                nextSixHourWeatherSymbol = nextSixHours.GetProperty("summary").GetProperty("symbol_code").GetString();
                nextSixHourPrecipitationAmount = nextSixHours.GetProperty("details").GetProperty("precipitation_amount").GetDouble();
            }

            string? nextTwelveHourWeatherSymbol = null;
            if (currentWeatherData.TryGetProperty("next_12_hours", out JsonElement nextTwelveHours))
            {
                nextTwelveHourWeatherSymbol = nextTwelveHours.GetProperty("summary").GetProperty("symbol_code").GetString();
            }

            string timeRaw = currentWeather.GetProperty("time").GetString()!;
            DateTime parsedDate = DateTime.Parse(timeRaw, CultureInfo.InvariantCulture, DateTimeStyles.AdjustToUniversal);
            var instantDetails = instant.GetProperty("details");

            var airPressureAtSeaLevel = instantDetails.GetProperty("air_pressure_at_sea_level");
            var airTemperature = instantDetails.GetProperty("air_temperature");
            var cloudAreaFraction = instantDetails.GetProperty("cloud_area_fraction");
            var relativeHumidity = instantDetails.GetProperty("relative_humidity");
            var windFromDirection = instantDetails.GetProperty("wind_from_direction");
            var windSpeed = instantDetails.GetProperty("wind_speed");

            var weatherItem = new YrWeatherInfoItem
            {
                AirPressureAtSeaLevel = airPressureAtSeaLevel.GetDouble(),
                AirTemperature = airTemperature.GetDouble(),
                CloudAreaFraction = cloudAreaFraction.GetDouble(),
                RelativeHumidity = relativeHumidity.GetDouble(),
                WindFromDirection = windFromDirection.GetDouble(),
                WindSpeed = windSpeed.GetDouble(),
                Time = parsedDate,
                NextHourPrecipitationAmount = nextOneHourPrecipitationAmount,
                NextHourWeatherSymbol = nextOneHourWeatherSymbol,
                NextSixHoursPrecipitationAmount = nextSixHourPrecipitationAmount,
                NextSixHoursWeatherSymbol = nextOneHourWeatherSymbol,
                NextTwelveHoursWeatherSymbol = nextTwelveHourWeatherSymbol
            };

            result.Add(weatherItem);

            if (onlyFirst)
            {
                break;
            }
        }

        return result;
    }

}


```