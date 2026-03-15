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

MCP is a standardized interface that enables AI applications to interact with a wide variety of data sources and tools in a consistent way. The architecture can be visualized as a layered graph, where the middle layer is the MCP protocol, connecting AI applications on one side and data sources/tools on the other.

<div class="mermaid" markdown="0">
%%{init: {'theme': 'base', 'themeVariables': {'fontSize': '22px'}}}%%
graph TD
    subgraph AI_Applications ["AI Applications & Interfaces"]
        direction TB
        A1["<b>Chat Interfaces</b><br/>(Windows Copilot, ChatGPT, Claude)"]
        A2["<b>IDEs & Code Editors</b><br/>(VS Code, Visual Studio, Cursor)"]
        A3["<b>Custom .NET AI Apps</b><br/>(Semantic Kernel, .NET SDKs)"]
    end

    subgraph Protocol_Layer ["Model Context Protocol — Middle Layer"]
        MCP["<b>● Model Context Protocol ●</b><br/>(Standardized Interface)"]
    end

    subgraph Data_Tools ["Data Sources & Tools"]
        direction TB
        D1["<b>File System</b><br/>(Windows File I/O, UNC Shares, OneDrive)"]
        D2["<b>Databases</b><br/>(SQL Server, Azure SQL, SQLite)"]
        D3["<b>Microsoft Cloud APIs</b><br/>(MS Graph, SharePoint, Azure Blob Storage)"]
        D4["<b>REST & Web APIs</b><br/>(GitHub, OpenWeather, Custom HTTP Services)"]
        D5["<b>Windows System APIs</b><br/>(WMI, Registry, Event Log, PowerShell)"]
    end

    AI_Applications <==> MCP
    MCP <==> Data_Tools

    style MCP fill:#00FF00,stroke:#333,stroke-width:4px
    style AI_Applications fill:#e1f5fe,stroke:#01579b
    style Data_Tools fill:#fff3e0,stroke:#e65100
</div>

---

## Key-takeaway : MCP is also both a contract and a protocol

It is important to limit of what a LLM can reach and define a contract that defines which tools, (data) resources and other capabilities that a LLM can access.

MCP is both a protocol and contract that defines how AI applications can request and receive data from various sources. It abstracts away the complexities of different APIs and data formats, allowing developers to focus on building AI applications without worrying about the underlying data access.

<div class="lecture-pager">
  <a href="ProgrammaticMcpDemo.html">← TOC</a>
  <a href="ProgrammaticMcpDemo-IntroToMcpDemo.html">Next: Intro to MCP Demo →</a>
</div>
