---
layout: default
title: Snowstorm - Prepare the Server
---

<div class="lecture-menu">
  <a href="Snowstorm-Overview.html">1. Overview</a>
  <a href="Snowstorm-Architecture.html">2. Architecture</a>
  <a href="Snowstorm-RF2.html">3. Get RF2 Data</a>
  <a href="Snowstorm-Setup.html" aria-current="page">4. Prepare the Server</a>
  <a href="Snowstorm-Start.html">5. Start Snowstorm</a>
  <a href="Snowstorm-Swagger.html">6. Open Swagger</a>
  <a href="Snowstorm-Import.html">7. Import RF2</a>
  <a href="Snowstorm-Verify.html">8. Verify and Next Steps</a>
</div>

# Prepare the Server

Install and start Docker Desktop. Allow sufficient memory and disk space: this example configures a 4 GB Elasticsearch heap and up to 4 GB for Snowstorm.

Clone the [demo repository](https://github.com/toreaurstadboss/Snowstorm.Snowmed.CSharp) and open its `Server` folder in PowerShell:

```powershell
git clone https://github.com/toreaurstadboss/Snowstorm.Snowmed.CSharp.git
Set-Location Snowstorm.Snowmed.CSharp/Server
New-Item -ItemType Directory -Force rf2
Copy-Item 'C:\path\to\your-release.zip' -Destination ./rf2/
```

Replace the source path with your downloaded RF2 ZIP. The [Compose file](https://github.com/toreaurstadboss/Snowstorm.Snowmed.CSharp/blob/main/Server/docker-compose.yml) mounts `./rf2` as `/rf2` in Snowstorm.

**Local development only:** Elasticsearch security is disabled. Elasticsearch binds to localhost, but Snowstorm's port `8080` is exposed on all host interfaces by the example. Do not expose this setup to untrusted networks or use it in production.

<div class="lecture-pager">
  <a href="Snowstorm-RF2.html">&larr; Get RF2 Data</a>
  <a href="Snowstorm.html">Lecture menu</a>
  <a href="Snowstorm-Start.html">Start Snowstorm &rarr;</a>
</div>