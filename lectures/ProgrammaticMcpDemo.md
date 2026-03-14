# Programmatic MCP Demo


### MCP Architecture — Systems View

MCP is a standardized interface that enables AI applications to interact with a wide variety of data sources and tools in a consistent way. The architecture can be visualized as a layered graph, where the middle layer is the MCP protocol, connecting AI applications on one side and data sources/tools on the other.

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'clusterBkg': '#e1f5fe11', 'fontSize': '16px'}}}%%
graph TD
    subgraph AI_Applications ["<big><b>AI Applications & Interfaces</b></big><br/><br/>"]
        direction TB
        A1["<b>Chat Interfaces</b><br/>(Windows Copilot, ChatGPT, Claude)"]
        A2["<b>IDEs & Code Editors</b><br/>(VS Code, Visual Studio, Cursor)"]
        A3["<b>Custom .NET AI Apps</b><br/>(Semantic Kernel, .NET SDKs)"]
    end

    subgraph Protocol_Layer ["<big><b>Middle Layer</b></big><br/>"]
        MCP{{"<b>● Model Context Protocol ●</b><br/>(Standardized Interface)"}}
    end

    subgraph Data_Tools ["<big><b>Data Sources & Tools</b></big><br/><br/>"]
        direction TB
        D1["<b>File System</b><br/>(Windows File I/O, UNC Shares, OneDrive)"]
        D2["<b>Databases</b><br/>(SQL Server, Azure SQL, SQLite)"]
        D3["<b>Microsoft Cloud APIs</b><br/>(MS Graph, SharePoint, Azure Blob Storage)"]
        D4["<b>REST & Web APIs</b><br/>(GitHub, OpenWeather, Custom HTTP Services)"]
        D5["<b>Windows System APIs</b><br/>(WMI, Registry, Event Log, PowerShell)"]
    end

    %% Bidirectional Relationships
    AI_Applications <==> MCP
    MCP <==> Data_Tools

    %% Styling
    style MCP fill:#00FF00,stroke:#333,stroke-width:4px
    style AI_Applications fill:#e1f5fe,stroke:#01579b
    style Data_Tools fill:#fff3e0,stroke:#e65100
    
    %% Source attribution
    caption[Source: Derived and tailored for .NET and Windows technology from diagram at modelcontextprotocol.io / Created by Tore Aurstad]

```

---

## Key-takeaway : MCP is also both a contract and a protocol

It is important to limit of what a LLM can reach and define a contract that defines which tools, (data) resources and other capabilities that a LLM can access. 

MCP is both a protocol and contract that defines how AI applications can request and receive data from various sources. It abstracts away the complexities of different APIs and data formats, allowing developers to focus on building AI applications without worrying about the underlying data access.



