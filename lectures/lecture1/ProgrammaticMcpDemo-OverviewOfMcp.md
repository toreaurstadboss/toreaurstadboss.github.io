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

## Key points about the MCP and LLM relationship and role division

🔷 **LLM and MCP. Orchestrator vs Connector.**
 MCP is the connector between LLM and data sources and tools (plus more) and LLM is the orchestrator and takes the decisions.

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

Important - The LLM will actively decide via input from the User and given context which tools to call from which MCP servers using MCP client, which will contact a MCP server. There can be multiple MCP servers that offers differents tools, resources and prompts. 

![MCP - Surroundings](/assets/images/lecture1/mcpserversmulitiplev2.png)

It is easy to mix up the different layers and components in the architecture. It is multiple tiers and layers in the architecture, but the key takeaway is that MCP is the connector between LLM and data sources and tools (plus more) and LLM is the orchestrator and takes the decisions.

The following sequence diagram shows how the responsobility are divided between the different components in the architecture. The LLM is the orchestrator and takes the decisions about which tool to call and what parameters to fill in, while MCP is the connector that allows the LLM to access the tools and data sources.

### MCP - Sequence diagram of the interactions between the different main components

The following UML sequence diagram (PlantUML 2.0 Dialect used here) shows the interactions between the components when using for example a tool in MCP Server. As we see, there are multiple layers, but an orderly interaction flow decided by given input and context. At the same time, there are some diffusion and spontaneous behavior of such a setup, given that the final strategy and choice of for example tools to use can vary but is always decided by the LLM ultimately. 

![MCP - Surroundings](/assets/images/lecture1/sequencediagram_mcp_flow_llm_mcp_client_mcp_service.png

---

## Key-points about the different the central participants in the architecture of MCP and LLMs 

🔷 **MCP is both a contract and a protocol**
 MCP is also both a contract and a protocol. It is an Open Source standard that allows multiple vendors to implement the protocol and contract in their own way, but still be able to interoperate with each other.

🔷 **User**
- Initiates interaction

🔷 **Application using AI with LLM / MCP functionality**
- Hosts the agent loop
- Coordinates LLM and MCP client

🔷 **LLM**
- Iniated by the application on behalf of user
- Handles the overall natural language understanding and decision making
- Processing user input and given context

🔷 **MCP Server**
- Contacted by LLM via a MCP client when required to do so to get necessary data or access remote tools
- Executes the tools 
- Accesses external resources
- Provides additional data and metadata such as tool descriptions and parameters to the LLM to use when using the MCP client

It is important to define and limit of what a LLM can reach and define a contract that defines which tools, (data) resources and other capabilities that a LLM can access.

MCP is both a protocol and contract that defines how AI applications can request and receive data from various sources. It abstracts away the complexities of different APIs and data formats, allowing developers to focus on building AI applications without worrying about the underlying data access.

<div class="lecture-pager">
  <a href="ProgrammaticMcpDemo.html">← TOC</a>
  <a href="ProgrammaticMcpDemo-IntroToMcpDemo.html">Next: Intro to MCP Demo →</a>
</div>
