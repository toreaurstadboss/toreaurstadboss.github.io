---
layout: default
title: Programmatic MCP Demo - MCP Client ChatController
---

<div class="lecture-menu">
  <a href="ProgrammaticMcpDemo-OverviewOfMcp.html">Overview of MCP</a>
  <a href="ProgrammaticMcpDemo-IntroToMcpDemo.html">Intro to MCP Demo</a>
  <a href="ProgrammaticMcpDemo-ServerSideOfMcpDemo.html">Serverside of MCP Demo</a>
  <a href="ProgrammaticMcpDemo-NominatimTool.html">Nominatim Tool</a>
  <a href="ProgrammaticMcpDemo-YrWeatherTool.html">Yr weather Tool</a>
  <a href="ProgrammaticMcpDemo-ChatController.html" aria-current="page">MCP Client (ChatController)</a>
  <a href="ProgrammaticMcpDemo-MetadataJsonRpc.html">MCP Metadata (JSON-RPC)</a>
  <a href="ProgrammaticMcpDemo-ModelInspector.html">Model Context Inspector</a>
</div>

# MCP Client — ChatController

The `ChatController` is the HTTP API entry point on the **client side** of the MCP demo. It accepts a user message via a `POST` request, connects to the MCP server at runtime, retrieves the available tools, and streams the LLM response back to the caller as plain text.

Key design points:

- **`IChatClient`** is injected via DI — the concrete implementation (Anthropic Claude in this demo) is wired up in `Program.cs`.
- **`McpClient.CreateAsync`** establishes a per-request connection to the MCP server over Streamable HTTP, fetches the tool list, and makes those tools available to the LLM via `ChatOptions.Tools`.
- Syntax note : The **Tools** are added using the spread operator (`[.. tools]`) to convert the list of tools from the MCP client into an array, which is the expected type for the `ChatOptions.Tools` property.
- **Streaming** — the controller writes each `ChatResponseUpdate` chunk directly to the response body as it arrives, giving the caller a real-time text stream without buffering the full response.
- **Model** — `claude-3-haiku-20240307` is used with a 1 000-token output cap. Haiku is fast and inexpensive, making it a good fit for a demo.
- A `TODO` comment marks the obvious next step: adding **chat history** so the LLM can build context across multiple turns.

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.AI;
using ModelContextProtocol.Client;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace WeatherServer.Http.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ChatController : ControllerBase
    {

        public class ChatRequest
        {
            [Required]
            public string Message { get; set; } = string.Empty;
        }

        private readonly ILogger<ChatController> _logger;
        private readonly IChatClient _chatClient;

        public ChatController(ILogger<ChatController> logger, IChatClient chatClient)
        {
            _logger = logger;
            _chatClient = chatClient;
        }

        [HttpPost(Name = "Chat")]
        [Produces("text/plain")]
        public async Task Chat([FromBody] ChatRequest chatRequest)
        {
            //TODO : Add support for 'chat history' to gradually build context here
            //       - repetively provide more info and context to the Claude LLM.

            Response.ContentType = "text/plain";
            Response.Headers.Append("Cache-Control", "no-cache");

            if (string.IsNullOrWhiteSpace(chatRequest.Message))
            {
                var error = Encoding.UTF8.GetBytes("Please provide your message.");
                await Response.Body.WriteAsync(error);
                await Response.Body.FlushAsync();
                return;
            }

            // Create MCP client connecting to our MCP server
            await using var mcpClient = await McpClient.CreateAsync(
                new HttpClientTransport(new HttpClientTransportOptions
                {
                    Endpoint = new Uri("https://localhost:7145/mcp"),
                    TransportMode = HttpTransportMode.StreamableHttp
                })
            );

            // Get available tools from the MCP server
            var tools = await mcpClient.ListToolsAsync();

            // Set up the chat messages
            var messages = new List<ChatMessage>
            {
                new ChatMessage(ChatRole.System, "You are a helpful assistant.")
            };
            messages.Add(new(ChatRole.User, chatRequest.Message));

            // Get streaming response and write each chunk directly to the response body
            await foreach (var update in _chatClient.GetStreamingResponseAsync(
                messages,
                new ChatOptions
                {
                    ModelId = "claude-3-haiku-20240307",
                    MaxOutputTokens = 1000,
                    Tools = [.. tools]
                }
            ))
            {
                var text = update.ToString();
                var bytes = Encoding.UTF8.GetBytes(text);
                await Response.Body.WriteAsync(bytes);
                await Response.Body.FlushAsync();
            }
        }

    }
}
```

<div class="lecture-pager">
  <a href="/lectures/lecture1/ProgrammaticMcpDemo-YrWeatherTool.html">← Previous: Yr weather Tool</a>
  <a href="/lectures/lecture1/ProgrammaticMcpDemo-MetadataJsonRpc.html">Next: MCP Metadata (JSON-RPC) →</a>
</div>
