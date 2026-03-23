---
layout: default
title: Programmatic MCP Demo - MCP Metadata with Swagger
---

<div class="lecture-menu">
  <a href="ProgrammaticMcpDemo-OverviewOfMcp.html">Overview of MCP</a>
  <a href="ProgrammaticMcpDemo-IntroToMcpDemo.html">Intro to MCP Demo</a>
  <a href="ProgrammaticMcpDemo-ServerSideOfMcpDemo.html">Serverside of MCP Demo</a>
  <a href="ProgrammaticMcpDemo-NominatimTool.html">Nominatim Tool</a>
  <a href="ProgrammaticMcpDemo-YrWeatherTool.html">Yr weather Tool</a>
  <a href="ProgrammaticMcpDemo-MetadataJsonRpc.html" aria-current="page">MCP Metadata (JSON-RPC)</a>
    <a href="ProgrammaticMcpDemo-ModelInspector.html">Model Context Inspector</a>
</div>

# MCP Metadata in Swagger (JSON-RPC)

This part shows how to expose MCP metadata in Swagger and retrieve metadata in JSON-RPC style.

Source post (from my Blogger website Coding Grounds):
- <a href="https://toreaurstad.blogspot.com/2025/11/metadata-retrieval-and-debugging-mcp.html" target="_blank">Metadata retrieval and debugging MCP servers</a>

## 1) Enable Swagger in Program.cs

```csharp
public static void Main(string[] args)
{
    var builder = WebApplication.CreateBuilder(args);

    //more code

    //Add swagger support
    builder.Services.AddControllers();
    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen();

    // some more code

    app.UseSwagger();
    app.UseSwaggerUI();
}
```

```xml
<PackageReference Include="Swashbuckle.AspNetCore" Version="9.0.6" />
<PackageReference Include="Swashbuckle.AspNetCore.SwaggerUI" Version="9.0.6" />
```

## 2) Expose tools metadata via controller

We use `IMcpClient` here from `ModelContextProtocol.Client` namespace to get the metadata of our MCP tools. The data is in Json-RPC format.

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using ModelContextProtocol.Client;

namespace WeatherServer.Web.Http.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ToolsController : ControllerBase
    {
        private readonly IMcpClient _client;
        private readonly IOptions<ModelContextProtocol.Protocol.Implementation> _mcpServerOptions;

        public ToolsController(IMcpClient client, IOptions<ModelContextProtocol.Protocol.Implementation> mcpServerOptions)
        {
            _client = client;
            _mcpServerOptions = mcpServerOptions;
        }

        [HttpGet(Name = "Overview")]
        [Produces("application/json")]
        public async Task<IActionResult> GetOverview()
        {
            var rpcRequest = new
            {
                jsonrpc = "2.0",
                method = "tools/list",
                id = 1
            };

            var tools = await _client.ListToolsAsync();
            return Ok(new
            {
                ServerName = _mcpServerOptions.Value.Title,
                Version = _mcpServerOptions.Value.Version,
                Tools = tools
            });
        }
    }
}
```

The core JSON-RPC shape is:

```json
{
  "jsonrpc": "2.0",
  "method": "tools/list",
  "id": 1
}
```

JSON-RPC/MCP references:
- <a href="https://modelcontextprotocol.io" target="_blank">modelcontextprotocol.io</a>
- <a href="https://modelcontextprotocol.io/specification/" target="_blank">MCP specification</a>

## Screenshots

Swagger JSON-RPC metadata output:

![MCP Swagger JSON-RPC metadata](/assets/images/lecture1/McpSwaggerJsonRpc.png)

JSON browser view of metadata document:

Here I used JsonCrack to watch Json online to watch the different metadata about the MCP tools.

![MCP JSON browser metadata view](/assets/images/lecture1/McpJsonBrowser1.png)

## Key takeaways

- Swagger is a practical way to surface MCP metadata from your HTTP server.
- Returning `ListToolsAsync()` gives a discoverable contract for clients.
- JSON-RPC structure (`jsonrpc`, `method`, `id`) is central for metadata operations.
- This makes debugging and documenting MCP server capabilities much easier.

<div class="lecture-pager">
  <a href="/lectures/lecture1/ProgrammaticMcpDemo-YrWeatherTool.html">← Previous: Yr weather Tool</a>
    <a href="/lectures/lecture1/ProgrammaticMcpDemo-ModelInspector.html">Next: Model Context Inspector →</a>
</div> 
