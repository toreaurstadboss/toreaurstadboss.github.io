---
layout: default
title: Programmatic MCP Demo - Nominatim Tool
---

<div class="lecture-menu">
    <a href="ProgrammaticMcpDemo-OverviewOfMcp.html">Overview of MCP</a>
    <a href="ProgrammaticMcpDemo-IntroToMcpDemo.html">Intro to MCP Demo</a>
    <a href="ProgrammaticMcpDemo-ServerSideOfMcpDemo.html">Serverside of MCP Demo</a>
    <a href="ProgrammaticMcpDemo-NominatimTool.html" aria-current="page">Nominatim Tool</a>
    <a href="ProgrammaticMcpDemo-YrWeatherTool.html">Yr weather Tool</a>
</div>

# Nominatim Tool

We look at the tools made for **Nominatim** and **Yr** APIs. The following HTTP clients are made:

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

### NominatimTool

- Note that tool method must be static and inside sealed class. This is a requirement for the MCP protocol and how the MCP server discovers and registers tools.
- Looking up latitude and longitude from a geographical place is done with the tool presented below. The tool is using the Nominatim API from OpenStreetMap to look up the latitude and longitude of a given place.
- Please observe that the tool defines one parameter, which is the place to look up. The parameter is decorated with a Description attribute, this is used to generate metadata about the tool and its parameters which can be used by clients to understand how to use the tool. This is part of the contract of the MCP protocol.
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

We use *IHttpClientFactory* to create the HTTP client that will use the right setup for accessing the Nominatim API. The client was defined in Program.cs.

Observe the use of Name and Description here. Here we provide both the metadata and the description that will be used by clients and the MCP protocol to understand how to use and limit usage of the tool.

The tool is inside an asynchronous method and returns a string with the latitude and longitude of the place looked up, if found.

<div class="lecture-pager">
    <a href="ProgrammaticMcpDemo-ServerSideOfMcpDemo.html">← Previous: Serverside of MCP Demo</a>
    <a href="ProgrammaticMcpDemo-YrWeatherTool.html">Next: Yr weather Tool →</a>
</div>
