


flowchart LR
    %% =========================
    %% Class definitions (crisp palette)
    %% =========================
    classDef userStyle rx:28, ry:28, stroke-width:2, fill:#E0F2FE, stroke:#0369A1
    classDef appStyle rx:30, ry:30, stroke-width:2, fill:#FEF3C7, stroke:#92400E
    classDef loopStyle rx:26, ry:26, stroke-width:2, fill:#FFF7ED, stroke:#C2410C
    classDef innerStyle rx:22, ry:22, stroke-dasharray:5 5, stroke-width:2, fill:#FFFFFF, stroke:#64748B
    classDef serverStyle rx:32, ry:32, stroke-width:3, fill:#DCFCE7, stroke:#166534
    classDef resourceDB rx:26, ry:26, stroke-width:2, fill:#DBEAFE, stroke:#1D4ED8
    classDef resourceFS rx:26, ry:26, stroke-width:2, fill:#EDE9FE, stroke:#5B21B6
    classDef resourceAPI rx:26, ry:26, stroke-width:2, fill:#FCE7F3, stroke:#9D174D

    %% =========================
    %% User
    %% =========================
    User["🧍 User"]
    class User userStyle

    LLM["LLM (Large language model)"]

    %% =========================
    %% Application with Agent Loop
    %% =========================
    subgraph App["Application using AI"]
        direction TB

        subgraph AgentLoop["Agent Loop"]
            direction TB
            MCPClient["MCP Client"]
            LLMClient["LLM Client"]
            Memory["Memory"]
        end
    end

    class App appStyle
    class AgentLoop loopStyle
    class MCPClient innerStyle
    class LLMClient innerStyle
    class Memory innerStyle

    %% =========================
    %% MCP Server
    %% =========================
    MCPServer["MCP server accessing DB"]
    class MCPServer serverStyle

        MCPServer2["MCP Server accessing API"]
    class MCPServer serverStyle

        MCPServer3["MCP Server accessing File system"]
    class MCPServer serverStyle

    %% =========================
    %% External Resources
    %% =========================
    DB["Database"]
    FS["File System"]
    API["API Server"]

    class DB resourceDB
    class FS resourceFS
    class API resourceAPI

    %% =========================
    %% Connections
    %% =========================
    User <--> App

    App <--> MCPServer

    App <--> LLM

    App <--> MCPServer2
    App<--> MCPServer3

    MCPServer <--> DB
    MCPServer2 <--> FS
    MCPServer3 <--> API