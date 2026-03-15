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
</div>

# Serverside of MCP Demo

### Serverside of the MCP Demo - WeatherServer.Web.Http

First off, I have used the following Nuget's. It probably are some newer versions of these packages, they worked with .NET 10 Target framework when I tested it out.

**WeatherServer.Web.Http.csproj Nuget packages:**
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

In addition to support HTTPS traffic as required for _SSE_ I set up a Powershell script in the repo to create a self-signed certificate and set up Kestrel to use it. Please note that the demo works best using Firefox browser as self-signed certificates become a bit tricky to do right in Chrome and Edge.

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

We also do more setup with the chat client here, passing in the ANTHROPIC_API_KEY from environment variable and setting up the model to use for chat completions.

```csharp
// Set up Anthropic client
builder.Services.AddChatClient(_ =>
    new ChatClientBuilder(new AnthropicClient(new APIAuthentication(builder.Configuration["ANTHROPIC_API_KEY"])).Messages)
        .UseFunctionInvocation()
        .Build());

// ..
app.MapMcp("/sse"); // SSE endpoint at /sse
```

<div class="lecture-pager">
    <a href="/lectures/lecture1/ProgrammaticMcpDemo-IntroToMcpDemo.html">← Previous: Intro to MCP Demo</a>
    <a href="/lectures/lecture1/ProgrammaticMcpDemo-NominatimTool.html">Next: Nominatim Tool →</a>
</div>
