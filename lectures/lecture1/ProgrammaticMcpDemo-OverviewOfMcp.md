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

MCP is a standardized interface that enables AI applications to interact with a wide variety of both local and remote data sources and tools in a consistent way. 

An overview of an Application using AI running an _Application Host Process_ and a diagram showing the clean boundaries are shown below. 

<a href="https://modelcontextprotocol.io/specification/2025-11-25/architecture" target="_blank">https://modelcontextprotocol.io/specification/2025-11-25/architecture</a>

![Application host process - MCP - Clean boundaries](/assets/images/lecture1/applicationhostprocessaimcpintro.png)

Communication can be done in two main means of communication:

- 🔷 **Streamable HTTP**: A transport protocol that allows for real-time, bidirectional communication between the client and server. It is designed to handle large volumes of data and can be used for applications that require low latency and high throughput.
- Bidirectional communication is achieved using a single HTTP connection that remains open for the duration of the communication session. This allows for efficient data transfer and reduces the overhead associated with establishing multiple connections.
- 🔷 **STDIO**: Standard I/O communication via a keyboard outputted to the console.
- 🔷 **SSE - Server side events**: Establishes two HTTP connections for both sending client requests and a persistent connection to send responses. There are multiple challenges with SSE - such as with load balancers, proxy performance, CORS, authentication. And added overhead in managing two HTTP connections.

This has resulted in SSE now being deprecated in MCP in favor of Streamable HTTP. 

_The reason SSE was phased out in favor of Streamable HTTP is detailed in this good blog post by Turkish software developer Fatih Kadir Akin._

#### Blog post about choice of SSE deprecation in MCP and move over to Streamabe HTTP :
<a href="https://blog.fka.dev/blog/2025-06-06-why-mcp-deprecated-sse-and-go-with-streamable-http/" target="_blank">
https://blog.fka.dev/blog/2025-06-06-why-mcp-deprecated-sse-and-go-with-streamable-http/
</a>
<br /><br />

The demo shown in the next lectures uses Streamable HTTP, which is the recommended transport for production use as of current. 

MCP is a protocol and a contract that allows language models to connect to tools and data sources. 


## Key point about the MCP and LLM relationship and role division

🔷 **LLM and MCP. Orchestrator vs Connector.**
 MCP is the connector between LLM and data sources and tools (plus more) and LLM is the orchestrator and takes the decisions.

 ---

### Key point about the payload of web based forms of communication in MCP - Streamable HTTP and older used Serverside events (SSE) 

🔷 **MCP Payload - Streamable HTTP or Serverside Events (SSE)**
- MCP uses Json-RPC as the payload format for both Streamable HTTP and Serverside Events (SSE) communication. Json-RPC is a lightweight remote procedure call (RPC) protocol encoded in JSON. It allows for simple and efficient communication between clients and servers, making it well-suited for the needs of MCP.
- Json-RCP messages can be request, response, error, notification. 
- The underlying communication allows full duplex communication, meaning that both the client and server can send messages independently of each other. This is important for real-time interactions and allows for a more dynamic and responsive experience when using MCP.

- Example Json-RPC request message

```json
{
  jsonrpc: "2.0";
  id: string | number;
  method: string;
  params?: {
    [key: string]: unknown;
  };
}
```

- Example Json-RCP response message
```json
{
  jsonrpc: "2.0";
  id: string | number;
  result: {
    [key: string]: unknown;
  }
}
```

**MCP uses Json-RCP 2.0 standard and extends this**

The extensions that MCP adds to the Json-RPC 2.0 standard are related to the specific needs of AI applications and the interaction between LLMs and tools/data sources. These extensions include additional fields and conventions for handling tool calls, resource access, and other interactions that are common in AI applications.

<a href="https://www.jsonrpc.org/specification" target="_blank">
SON-RPC 2.0 Specification - https://www.jsonrpc.org/specification
</a>

---

Let's also consider how the LLM will provide information (parameters) to a tool or resources using MCP. 

🔷 **LLM parameter handling to MCP server features (tools / resources)**
MCP populates tool parameters by combining:
- 🔷Your tool’s parameter schema (from attributes + .NET type metadata)
- 🔷The natural‑language description you provide
- 🔷The LLM’s reasoning over the user’s request + context
- 
The LLM chooses which tool to call and fills in the parameters by matching the user’s intent to the tool’s schema.
The MCP runtime does not decide values — it only exposes the schema. The LLM decides.


The protocol can be read about in more detail at the web site : 

<a href="https://modelcontextprotocol.io" target="_blank">https://modelcontextprotocol.io</a>


## MCP environment and overall architecture
**A system diagram of the architecture of MCP is shown below, where MCP is the connector between the LLM and the data sources and tools. The LLM is the orchestrator and takes the decisions about which tool to call and what parameters to fill in.**

![MCP - Surroundings](/assets/images/lecture1/systemsviewmcpsurroundings.png)

The _Basic MCP Client/Server Architecture_ is shown in the diagram below, showing how a user can via an agent of an AI application contact a MCP server via an MCP client. 

Important - The LLM will actively decide via input from the User and given context which tools to call from which MCP servers using MCP client, which will contact a MCP server. There can be multiple MCP servers that offer different tools, resources and prompts. 

### MCP - Basic Client/Server architecture

![MCP - Surroundings](/assets/images/lecture1/mcpserversmulitiplev2.png)

It is easy to mix up the different layers and components in the architecture. It is multiple tiers and layers in the architecture, but the key takeaway is that MCP is the connector between LLM and data sources and tools (plus more) and LLM is the orchestrator and takes the decisions.

The following sequence diagram shows how the responsibility is divided between the different components in the architecture. The LLM is the orchestrator and takes the decisions about which tool to call and what parameters to fill in, while MCP is the connector that allows the LLM to access the tools and data sources.

# MCP - Sequence diagram of the interactions between the different main components

The following UML sequence diagram (PlantUML 2.0 Dialect used here) shows the interactions between the components when using for example a tool in MCP Server. As we see, there are multiple layers, but an orderly interaction flow decided by given input and context. At the same time, there are some diffusion and spontaneous behavior of such a setup, given that the final strategy and choice of for example tools to use can vary but is always decided by the LLM ultimately. 

### Sequence diagram of the interactions between the different main components in MCP and LLM architecture
(PlantUML 2.0 diagram used here)

![MCP - Surroundings](/assets/images/lecture1/mcp_sequence.png)

---

### Key-points about the different the central participants in the architecture of MCP and LLMs 

🔷 **MCP is both a contract and a protocol**
 MCP is also both a contract and a protocol. It is an Open Source standard that allows multiple vendors to implement the protocol and contract in their own way, but still be able to interoperate with each other.

🔷 **User**
- Initiates interaction

🔷 **Application using AI with LLM / MCP functionality**
- Hosts the agent loop
- Coordinates LLM and MCP client

🔷 **LLM**
- Initiated by the application on behalf of user
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
