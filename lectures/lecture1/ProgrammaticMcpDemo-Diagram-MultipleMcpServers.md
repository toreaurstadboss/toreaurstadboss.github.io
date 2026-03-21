
flowchart LR
    %% =========================
    %% Class definitions
    %% =========================
    classDef roundedSolid rx:20, ry:20, stroke-width:2, fill:#EFEF20, stroke:#334155
    classDef roundedDashed rx:18, ry:18, stroke-dasharray:6 4, stroke-width:2, fill:#90FE90, stroke:#64748B
    classDef userStyle rx:20, ry:20, stroke-width:2, fill:#ECFEFF, stroke:#0891B2
    classDef llmStyle rx:20, ry:20, stroke-width:2, fill:#FDF4FF, stroke:#A21CAF
    classDef serverStyle rx:20, ry:20, stroke-width:2, fill:#F0FDF4, stroke:#15803D

    %% =========================
    %% User
    %% =========================
    User["🧍 User"]
    class User userStyle

    %% =========================
    %% AI Application / Agent
    %% =========================
    subgraph AIApp["AI Application (Agent)"]
        direction TB

        subgraph MCPClient["MCP Client"]
            direction TB
            AgentLoop["Agent Loop"]
            Memory["Memory"]
        end
    end

    class AIApp roundedSolid
    class MCPClient roundedDashed
    class AgentLoop roundedDashed
    class Memory roundedDashed

    %% =========================
    %% MCP Servers
    %% =========================
    subgraph MCPServer1["MCP Server A"]
        direction TB
        Tools1["Tools"]
        Prompts1["Prompts"]
        Resources1["Resources"]
    end

    subgraph MCPServer2["MCP Server B"]
        direction TB
        Tools2["Tools"]
        Prompts2["Prompts"]
        Resources2["Resources"]
    end

    subgraph MCPServer3["MCP Server C"]
        direction TB
        Tools3["Tools"]
        Prompts3["Prompts"]
        Resources3["Resources"]
    end

    class MCPServer1 serverStyle
    class MCPServer2 serverStyle
    class MCPServer3 serverStyle

    class Tools1 roundedDashed
    class Prompts1 roundedDashed
    class Resources1 roundedDashed
    class Tools2 roundedDashed
    class Prompts2 roundedDashed
    class Resources2 roundedDashed
    class Tools3 roundedDashed
    class Prompts3 roundedDashed
    class Resources3 roundedDashed

    %% =========================
    %% LLM
    %% =========================
    LLM["LLM"]
    class LLM llmStyle

    %% =========================
    %% Connections
    %% =========================
    User <--> AIApp

    AgentLoop <--> MCPServer1
    AgentLoop <--> MCPServer2
    AgentLoop <--> MCPServer3

    AgentLoop --> LLM
    LLM --> AgentLoop