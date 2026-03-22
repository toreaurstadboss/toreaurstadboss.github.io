---
layout: default
title: Programmatic MCP Demo - Model Context Inspector
---

<div class="lecture-menu">
  <a href="ProgrammaticMcpDemo-OverviewOfMcp.html">Overview of MCP</a>
  <a href="ProgrammaticMcpDemo-IntroToMcpDemo.html">Intro to MCP Demo</a>
  <a href="ProgrammaticMcpDemo-ServerSideOfMcpDemo.html">Serverside of MCP Demo</a>
  <a href="ProgrammaticMcpDemo-NominatimTool.html">Nominatim Tool</a>
  <a href="ProgrammaticMcpDemo-YrWeatherTool.html">Yr weather Tool</a>
  <a href="ProgrammaticMcpDemo-MetadataJsonRpc.html">MCP Metadata (JSON-RPC)</a>
  <a href="ProgrammaticMcpDemo-ModelInspector.html" aria-current="page">Model Context Inspector</a>
</div>

# Model Context Inspector

From the same blog post, we can also inspect MCP metadata and tools interactively using Model Context Inspector.

Source post:
- <a href="https://toreaurstad.blogspot.com/2025/11/metadata-retrieval-and-debugging-mcp.html" target="_blank">Metadata retrieval and debugging MCP servers</a>

## Run Inspector with npx

```powershell
npx @modelcontextprotocol/inspector --startup-url "https://localhost:7145/mcp"
```

If local self-signed TLS gives issues in local dev, I used this temporary workaround:

```powershell
$env:NODE_TLS_REJECT_UNAUTHORIZED=0
npx @modelcontextprotocol/inspector --startup-url "https://localhost:7145/mcp"
```

Inside Inspector, use:
- Transport Type: Streamable HTTP
- URL: `https://localhost:7145/mcp`
- Connection Type: Via Proxy

The MCP endpoint on server side is:

```csharp
app.MapMcp("/mcp"); // This exposes the SSE endpoint at /sse
```

## Screenshot

Model Context Inspector in use:

![Model Context Inspector local dev](/assets/images/lecture1/McpLocalDevPart2.png)

## Key notes (from the blog post)

- Add Swagger and Swagger UI on server side and expose an endpoint that lists JSON-RPC metadata for tools (and optionally prompts/resources).
- Use Model Context Inspector to inspect server capabilities and run tools without going through a chat client.

<div class="lecture-pager">
  <a href="/lectures/lecture1/ProgrammaticMcpDemo-MetadataJsonRpc.html">← Previous: MCP Metadata (JSON-RPC)</a>
  <a href="/lectures/lecture1/ProgrammaticMcpDemo.html">Back to TOC →</a>
</div>
