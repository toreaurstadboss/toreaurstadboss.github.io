---
layout: default
title: Programmatic MCP Demo - Yr weather Tool
---

<div class="lecture-menu">
    <a href="ProgrammaticMcpDemo-OverviewOfMcp.html">Overview of MCP</a>
    <a href="ProgrammaticMcpDemo-IntroToMcpDemo.html">Intro to MCP Demo</a>
    <a href="ProgrammaticMcpDemo-ServerSideOfMcpDemo.html">Serverside of MCP Demo</a>
    <a href="ProgrammaticMcpDemo-NominatimTool.html">Nominatim Tool</a>
    <a href="ProgrammaticMcpDemo-YrWeatherTool.html" aria-current="page">Yr weather Tool</a>
</div>

# Yr weather Tool

The Yr tool is defined in the same way as the Nominatim tool, it is a sealed class decorated with the [McpServerToolType] attribute and it defines methods decorated with the [McpServerTool] attribute.

The tool has got instructions in the Description that tell the tool to use the Nominatim tool to look up coordinates for the place that is to be checked for weather prediction.

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
    - It is very important that the correct url is used, longitude and latitude here will be provided . $""weatherapi/locationforecast/2.0/compact?lat={{latitude}}&lon={{longitude}}""
    - Always include the latitude and longitude used.
    - Always inform about which url was used to get the data here.
    - Inform about the time when the weather is.
    - Always include the 'time' field from the result to indicate when the weather data is valid.
    - Clearly state that the data was retrieved using 'YrWeatherCurrentWeather'.
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
}
```

<div class="lecture-pager">
    <a href="ProgrammaticMcpDemo-NominatimTool.html">← Previous: Nominatim Tool</a>
    <a href="ProgrammaticMcpDemo.html">Back to TOC →</a>
</div>
