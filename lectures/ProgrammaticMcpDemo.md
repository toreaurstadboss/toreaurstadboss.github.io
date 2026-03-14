# Programmatic MCP Demo


### MCP Architecture — Systems View

MCP is a standardized interface that enables AI applications to interact with a wide variety of data sources and tools in a consistent way. The architecture can be visualized as a layered graph, where the middle layer is the MCP protocol, connecting AI applications on one side and data sources/tools on the other.

```mermaid

graph TD
    subgraph AI_Applications [<b>AI Applications & Interfaces</b>]
        direction TB
        A1["<b>Chat Interfaces</b><br/>(Windows Copilot, ChatGPT, Claude)"]
        A2["<b>IDEs & Code Editors</b><br/>(VS Code, Visual Studio, Cursor)"]
        A3["<b>Custom .NET AI Apps</b><br/>(Semantic Kernel, .NET SDKs)"]
    end

    subgraph Protocol_Layer [<b>Middle Layer</b>]
        MCP{{"<b>● Model Context Protocol ●</b><br/>(Standardized Interface)"}}
    end

    subgraph Data_Tools [<b>Data Sources & Tools</b>]
        direction TB
        D1["<b>Microsoft Ecosystem</b><br/>(Graph API, SQL Server, SharePoint)"]
        D2["<b>Google Ecosystem</b><br/>(Google Drive, Maps, BigQuery)"]
        D3["<b>Anthropic Ecosystem</b><br/>(Claude Desktop Tools, Brave Search)"]
        D4["<b>Local & External APIs</b><br/>(NTFS, REST Services, GitHub)"]
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



