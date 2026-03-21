---
layout: default
title: Programmatic MCP Demo - Overview of MCP
---

<div class="lecture-menu">
  <a href="ProgrammaticMcpDemo-OverviewOfMcp.html" aria-current="page">Overview of MCP</a>
  <a href="ProgrammaticMcpDemo-IntroToMcpDemo.html">Intro to MCP Demo</a>
  <a href="ProgrammaticMcpDemo-ServerSideOfMcpDemo.html">Serverside of MCP Demo</a>
  <a href="ProgrammaticMcpDemo-NominatimTool.html">Nominatim Tool</a>
  <a href="ProgrammaticMcpDemo-YrWeatherTool.html">Yr weather Tool</a>
  <a href="ProgrammaticMcpDemo-MetadataJsonRpc.html">MCP Metadata (JSON-RPC)</a>
  <a href="ProgrammaticMcpDemo-ModelInspector.html">Model Context Inspector</a>
</div>

# Overview of MCP

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

### MCP Architecture — Systems View

MCP is a standardized interface that enables AI applications to interact with a wide variety of data sources and tools in a consistent way. 

MCP is a protocol and a contract that allows language models to connect to tools and data sources. 

The following systems view diagram puts MCP in the middle as a connector between the LLMs in a AIs system and possible multiple data source. 

## Key takeaway : MCP is the connector between LLM and data sources and tools (plus more) and LLM is the orchestrator and takes the decisions.

MCP is a way to provide data for the LLM defined via these three core concepts. 

MCP populates tool parameters by combining:
- Your tool’s parameter schema (from attributes + .NET type metadata)
- The natural‑language description you provide
- The LLM’s reasoning over the user’s request + context
The LLM chooses which tool to call and fills in the parameters by matching the user’s intent to the tool’s schema.
The MCP runtime does not decide values — it only exposes the schema. The LLM decides.


The protocol can be read about in more detail at the web site : 

[https://modelcontextprotocol.io](https://modelcontextprotocol.io)

A system diagram of the architecture of MCP is shown below, where MCP is the connector between the LLM and the data sources and tools. The LLM is the orchestrator and takes the decisions about which tool to call and what parameters to fill in.

![MCP - Surroundings](/assets/images/lecture1/systemsviewmcpsurroundings.png)

The _Basic MCP Client/Server Architecture_ is shown in the diagram below, showing how a user can via an agent of an AI application contact a MCP server via an MCP client. 

![MCP - Surroundings](/assets/images/lecture1/mcpserversmulitiplev2.png)


---

## Key-takeaway : MCP is also both a contract and a protocol

It is important to define and limit of what a LLM can reach and define a contract that defines which tools, (data) resources and other capabilities that a LLM can access.

MCP is both a protocol and contract that defines how AI applications can request and receive data from various sources. It abstracts away the complexities of different APIs and data formats, allowing developers to focus on building AI applications without worrying about the underlying data access.

<div class="lecture-pager">
  <a href="ProgrammaticMcpDemo.html">← TOC</a>
  <a href="ProgrammaticMcpDemo-IntroToMcpDemo.html">Next: Intro to MCP Demo →</a>
</div>
