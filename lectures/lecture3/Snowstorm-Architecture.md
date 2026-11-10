---
layout: default
title: Snowstorm - Architecture
---

<div class="lecture-menu">
  <a href="Snowstorm-Overview.html">1. Overview</a>
  <a href="Snowstorm-Architecture.html" aria-current="page">2. Architecture</a>
  <a href="Snowstorm-RF2.html">3. Get RF2 Data</a>
  <a href="Snowstorm-Setup.html">4. Prepare the Server</a>
  <a href="Snowstorm-Start.html">5. Start Snowstorm</a>
  <a href="Snowstorm-Swagger.html">6. Open Swagger</a>
  <a href="Snowstorm-Import.html">7. Import RF2</a>
  <a href="Snowstorm-Verify.html">8. Verify and Next Steps</a>
</div>

# How the Pieces Fit

| Component | Role |
|---|---|
| Snowstorm | Terminology API on port `8080` |
| Elasticsearch | Indexes and stores terminology data on port `9200` |
| RF2 ZIP | Release data imported into Snowstorm |
| Docker volumes | Persist Elasticsearch data and make the ZIP available to Snowstorm |

## What is in RF2?

Concepts, descriptions, relationships and reference set items work together to represent clinical terminology.

![RF2 component diagram showing concepts, descriptions, relationships and reference set items](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgxsIjlm_vbV42sLbhpKImUBEbG07r6K6vjxGVHIKgbh6oN1PqvOOhqo4PefyyLeql13QSdjTqi0OoTAFHyiA-xEV2gR_SXWwIL1U7q0D0iPEwc8PlBLPPK_2I1-18fGAMTH6DXMsfabFYdFktX8Xsq-jiGc36muzJreuWBfVgReyvSWbuTllECTbhyRnE/s1600/SnomedRf2ComponentDiagram.png)

<div class="lecture-pager">
  <a href="Snowstorm-Overview.html">&larr; Overview</a>
  <a href="Snowstorm.html">Lecture menu</a>
  <a href="Snowstorm-RF2.html">Get RF2 Data &rarr;</a>
</div>