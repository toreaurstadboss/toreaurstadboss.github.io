---
layout: default
title: Programmatic MCP Demo - Serverside of MCP Demo
---

<div class="lecture-menu">
    <a href="ProgrammaticMcpDemo-OverviewOfMcp.html">Overview of MCP</a>
    <a href="ProgrammaticMcpDemo-IntroToMcpDemo.html">Intro to MCP Demo</a>
    <a href="ProgrammaticMcpDemo-ServerSideOfMcpDemo.html" aria-current="page">Serverside of MCP Demo</a>
    <a href="ProgrammaticMcpDemo-NominatimTool.html">Nominatim Tool</a>
    <a href="ProgrammaticMcpDemo-YrWeatherTool.html">Yr weather Tool</a>
    <a href="ProgrammaticMcpDemo-MetadataJsonRpc.html">MCP Metadata (JSON-RPC)</a>
    <a href="ProgrammaticMcpDemo-ModelInspector.html">Model Context Inspector</a>
</div>

# Serverside of MCP Demo

### Serverside of the MCP Demo - WeatherServer.Web.Http

First off, I have used the following NuGet packages. I have recently updated the Demo to use .NET 10 and moved from using SSE to Streamable HTTP and verified that it still works after the upgrades.

**WeatherServer.Web.Http.csproj Nuget packages:**
```xml
<ItemGroup>
<PackageReference Include="Microsoft.Extensions.Hosting" Version="10.0.3" />
<PackageReference Include="Microsoft.Extensions.Http" Version="10.0.3" />
<PackageReference Include="ModelContextProtocol.AspNetCore" Version="1.1.0" />
<PackageReference Include="Swashbuckle.AspNetCore" Version="10.1.5" />
<PackageReference Include="Swashbuckle.AspNetCore.SwaggerUI" Version="10.1.5" />
<PackageReference Include="ModelContextProtocol" Version="1.1.0" />
<PackageReference Include="Anthropic.SDK" Version="5.10.0" />
<PackageReference Include="Microsoft.Extensions.AI" Version="10.3.0" />
</ItemGroup>
```

The packages used here are covering different aspects of the MCP protocol and the implementation of the demo.

- Anthropic.SDK and ModelContextProtocol are the main packages that are used to implement the MCP protocol and to interact with the Anthropic Claude models.
- The ModelContextProtocol.AspNetCore package is used to set up the MCP protocol in an ASP.NET Core web application.
- Microsoft.Extensions.AI is used to integrate AI capabilities into the application, allowing us to easily call the Anthropic API and use the Claude models.
- Swashbuckle.AspNetCore and Swashbuckle.AspNetCore.SwaggerUI are used to set up Swagger UI for the application, which allows us to visualize the tools and resources that are offered in the MCP protocol.

**Program.cs**

First off, we add MCP support using _AddMcpServer()_ on *builder.Services* and then we add the tools we have made and want to expose through the MCP protocol.

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

Note that assembly scanning is supported, we could have used:

_.WithToolsFromAssembly()_ to add ALL MCP tools in an assembly (project).

I wanted also to be able to run the Server side using Swagger and chat with the Server itself, so a client for the server is actually also set up here.

Further MCP setup is done in `Program.cs` 

```csharp 
  builder.Services.Configure<McpClientOptions>(options =>
  {
      builder.Configuration.GetSection("McpClient");
  });

  var mcpEndpoint = builder.Configuration.GetSection("McpClient:Endpoint").Value;

  builder.Services.AddSingleton<McpClient>(_ =>
  {
      return McpClient.CreateAsync(
          new HttpClientTransport(new HttpClientTransportOptions
          {
              Endpoint = new Uri(mcpEndpoint!),
              TransportMode = HttpTransportMode.StreamableHttp
          })
      ).GetAwaiter().GetResult();
  });

  builder.Services.Configure<ModelContextProtocol.Protocol.Implementation>(options =>
  {
      options.Title = "WeatherMcpDemoServer";
      options.Version = "1.2"; 
  });
```

We also do more setup with the chat client here, passing in the ANTHROPIC_API_KEY from environment variable and setting up the model to use for chat completions.

```csharp
// Set up Anthropic client
builder.Services.AddChatClient(_ =>
    new ChatClientBuilder(new AnthropicClient(new APIAuthentication(builder.Configuration["ANTHROPIC_API_KEY"])).Messages)
        .UseFunctionInvocation()
        .Build());

// ..
app.MapMcp("/mcp"); 
```

<div class="lecture-pager">
    <a href="/lectures/lecture1/ProgrammaticMcpDemo-IntroToMcpDemo.html">← Previous: Intro to MCP Demo</a>
    <a href="/lectures/lecture1/ProgrammaticMcpDemo-NominatimTool.html">Next: Nominatim Tool →</a>
</div>
