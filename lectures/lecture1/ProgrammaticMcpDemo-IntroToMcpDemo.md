---
layout: default
title: Programmatic MCP Demo - Intro to MCP Demo
---

<div class="lecture-menu">
  <a href="ProgrammaticMcpDemo-OverviewOfMcp.html">Overview of MCP</a>
  <a href="ProgrammaticMcpDemo-IntroToMcpDemo.html" aria-current="page">Intro to MCP Demo</a>
  <a href="ProgrammaticMcpDemo-ServerSideOfMcpDemo.html">Serverside of MCP Demo</a>
  <a href="ProgrammaticMcpDemo-NominatimTool.html">Nominatim Tool</a>
  <a href="ProgrammaticMcpDemo-YrWeatherTool.html">Yr weather Tool</a>
  <a href="ProgrammaticMcpDemo-MetadataJsonRpc.html">MCP Metadata (JSON-RPC)</a>
</div>

# Intro to MCP Demo

## The MCP Demo : Yr weather service using Model Context Protcol

>The demo is a simple weather service that uses Yr web >services to provide weather information.

**What we will build**

The demo is a web application where you can ask about the weather at a given place and get the response which will use a tool that uses Yr web services to get weather information. The demo demonstrates using MCP tools. 

**Tools** is a category of capabilities that are offered in the MCP protocol.

#### Server features that are offered with MCP are:
- Tools: Executable functions that allow models to perform actions or retrieve information
- Resources: Structured data or content that provides additional context to the model
- Prompts: Predefined templates or instructions that guide language model interactions

The screenshot below shows the Demo in action, where I ask about the weather in Trondheim tonight. I specify it to include details also.

### Screenshot of the demo

![claude](/assets/images/lecture1/claudechatdemo2.png)


As the screenshot shows, we can ask free-form about the weather the AI LLM model which makes it possible to have a more natural conversation about the weather than just using a website to look up the weather.

_Example of a more advanced demo would be:
We could have combined this for example with Synthesized Text to Speech voice assistant and Speech to Text to have a natural conversation with the AI model._


The demo here focuses on the following _Server Feature_ of MCP :  **Tools**.

Yr is a popular weather service in Norway delivered by Norwegian Meteorological Institute (met.no) in Oslo, Norway.

In the same demo repo, you find code how you can expose metadata about the tools the MCP offers.

We can with for example Swagger present metadata information about the tools that are offered in the MCP protocol. This is a good way to present the contract of the MCP protocol and what capabilities it offers.

![Swagger tools Json RPC](/assets/images/lecture1/toolsmetadatajsonrpcmcpdemo1.png)

### Github repo for the MCP Weather Demo

The Github repo is publicly available here for those who want to explore the code and try it out themselves:

[https://github.com/toreaurstadboss/WeatherMCPDemo](https://github.com/toreaurstadboss/WeatherMCPDemo)

Note that to run the demo, you must have an account at Anthropic web site and set up an API key here:

[https://console.anthropic.com/dashboard](https://console.anthropic.com/dashboard)

It is possible to pay as you use to test out Anthropic LLMs. I paid 20 dollars a year ago and still have not spent all of it. And this includes a lot of testing and playing around using the Anthropic Claude service in the demos I have written.

The model I have been using while testing is _claude-3-haiku-20240307_. It is some months since I worked most with the demo and I expect **newer Claude** models should be possible to test of course.

<div class="lecture-pager">
  <a href="/lectures/lecture1/ProgrammaticMcpDemo-OverviewOfMcp.html">← Previous: Overview of MCP</a>
  <a href="/lectures/lecture1/ProgrammaticMcpDemo-ServerSideOfMcpDemo.html">Next: Serverside of MCP Demo →</a>
</div>
