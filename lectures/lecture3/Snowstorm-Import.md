---
layout: default
title: Snowstorm - Import RF2
---

<div class="lecture-menu">
  <a href="Snowstorm-Overview.html">1. Overview</a>
  <a href="Snowstorm-Architecture.html">2. Architecture</a>
  <a href="Snowstorm-RF2.html">3. Get RF2 Data</a>
  <a href="Snowstorm-Setup.html">4. Prepare the Server</a>
  <a href="Snowstorm-Start.html">5. Start Snowstorm</a>
  <a href="Snowstorm-Swagger.html">6. Open Swagger</a>
  <a href="Snowstorm-Import.html" aria-current="page">7. Import RF2</a>
  <a href="Snowstorm-Verify.html">8. Verify and Next Steps</a>
</div>

# Import the RF2 ZIP

In a second PowerShell window, use the ZIP's **container path**, replacing the filename with your own:

```powershell
$body = @{
    branchPath = 'MAIN'
    filePath = '/rf2/your-release.zip'
    type = 'FULL'
    createCodeSystemVersion = $true
} | ConvertTo-Json

Invoke-RestMethod -Uri 'http://localhost:8080/imports/start-local-file-import' `
    -Method Post -ContentType 'application/json' -Body $body
```

This follows the blog's full-history import. The ZIP must contain Full RF2 files. For a faster development setup, Snowstorm recommends `SNAPSHOT`; use that type with a release containing Snapshot files. See [Snowstorm's loading guide](https://github.com/IHTSDO/snowstorm/blob/master/docs/loading-snomed.md).

Imports can take a long time, especially for full history. Watch the container logs and wait for completion or errors before querying. Use a fresh instance and the appropriate branch for your edition.

<div class="lecture-pager">
  <a href="Snowstorm-Swagger.html">&larr; Open Swagger</a>
  <a href="Snowstorm.html">Lecture menu</a>
  <a href="Snowstorm-Verify.html">Verify and Next Steps &rarr;</a>
</div>