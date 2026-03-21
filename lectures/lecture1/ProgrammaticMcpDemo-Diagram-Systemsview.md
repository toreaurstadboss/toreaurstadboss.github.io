
## Systems view showing the connections between different components shown from the MCP perspective. All interactions can be bidirectional. Important - LLM orchestrates and decides about the data flows and functionality that MCP offers. 

<div class="mermaid" markdown="0">
%%{init: {'theme': 'base', 'themeVariables': {'fontSize': '20px'}}}%%
graph TD
    subgraph AI_Applications ["AI Applications & Interfaces"]
        direction TB
        A1["<b>Chat Interfaces</b><br/>(Windows Copilot, ChatGPT, Claude)"]
        A2["<b>IDEs & Code Editors</b><br/>(VS Code, Visual Studio, Cursor)"]
        A3["<b>Custom .NET AI Apps</b><br/>(Semantic Kernel, .NET SDKs)"]
    end

    subgraph Protocol_Layer ["Model Context Protocol — Middle Layer"]
        MCP["<b>● Model Context Protocol ●</b><br/>(Standardized Interface. Following Server features of MCP can be exposed to the outside : <ul><li>Tools</li><li>Prompts</li><li>Resources</li>"]
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