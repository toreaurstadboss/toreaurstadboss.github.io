---
layout: default
title: Snowstorm - Verify and Next Steps
---

<div class="lecture-menu">
  <a href="Snowstorm-Overview.html">1. Overview</a>
  <a href="Snowstorm-Architecture.html">2. Architecture</a>
  <a href="Snowstorm-RF2.html">3. Get RF2 Data</a>
  <a href="Snowstorm-Setup.html">4. Prepare the Server</a>
  <a href="Snowstorm-Start.html">5. Start Snowstorm</a>
  <a href="Snowstorm-Swagger.html">6. Open Swagger</a>
  <a href="Snowstorm-Import.html">7. Import RF2</a>
  <a href="Snowstorm-Verify.html" aria-current="page">8. Verify and Next Steps</a>
</div>

# Verify the Import

After the import completes, try a concept lookup and a search:

- [SNOMED CT root concept](http://localhost:8080/browser/MAIN/concepts/138875005)
- [Search for asthma](http://localhost:8080/MAIN/concepts?term=asthma)

A response with terminology data confirms the server can read the imported content. If it fails, check the import logs, branch and ZIP path.

## Stop and restart

Press `Ctrl+C` in the Compose terminal, or run `docker compose down` from the `Server` folder. The Elasticsearch named volume preserves imported data; do **not** use `docker compose down -v` unless you intend to delete it.

## Later: a C# client

A future lecture can build a C# client for concept lookup and search. Snowstorm also exposes a [FHIR terminology API](https://github.com/IHTSDO/snowstorm/blob/master/docs/using-the-fhir-api.md), worth considering alongside its specialist SNOMED CT API.

<div class="lecture-pager">
  <a href="Snowstorm-Import.html">&larr; Import RF2</a>
  <a href="Snowstorm.html">Back to lecture menu &rarr;</a>
</div>