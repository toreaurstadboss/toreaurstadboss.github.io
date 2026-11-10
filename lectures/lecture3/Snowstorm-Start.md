---
layout: default
title: Snowstorm - Start Snowstorm
---

<div class="lecture-menu">
  <a href="Snowstorm-Overview.html">1. Overview</a>
  <a href="Snowstorm-Architecture.html">2. Architecture</a>
  <a href="Snowstorm-RF2.html">3. Get RF2 Data</a>
  <a href="Snowstorm-Setup.html">4. Prepare the Server</a>
  <a href="Snowstorm-Start.html" aria-current="page">5. Start Snowstorm</a>
  <a href="Snowstorm-Swagger.html">6. Open Swagger</a>
  <a href="Snowstorm-Import.html">7. Import RF2</a>
  <a href="Snowstorm-Verify.html">8. Verify and Next Steps</a>
</div>

# Start the Containers

From the `Server` folder, run:

```powershell
docker compose up
```

The first run downloads the images. Snowstorm starts after Elasticsearch passes its health check; watch the logs for startup errors.

![Docker Desktop showing the Snowstorm and Elasticsearch containers](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjaQA-0a_c699TAsIWM8RFwx3znCtxtJzD473cidaVSeSMeImQQV1HKIplVsdYoI1Uhh4Fn4FZ4tyVvfPAjMyUrVv2i022djNF4SorIyt0LBLdc0reYiltLOACA1d1dR-muUbEckAdDI4GUwQqaq6OfdVTDKnH96kB_I46Qb6BM8i9DeoQjJme0APkPLLo/s1600/dockersnomed.png)

![Snowstorm startup output in Docker](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgyOyUS6fwhHY1aZGajgbfAHYOub5H2A-OJDRcm_vHS3Foai9fsLL4Pgt9oYkUixnR-yTKTBNVVxlWheEBxCTVb-KR5q24GtAY5lja70VjxgsZf6Mqa5rbKxPAGB7VxOsyqI5sUWC9jcDiAjng6HE-GAATPXRshu66VNFVKiZZx18mExh0hPRIj9eLBIcE/s1600/snomedloading.png)

<div class="lecture-pager">
  <a href="Snowstorm-Setup.html">&larr; Prepare the Server</a>
  <a href="Snowstorm.html">Lecture menu</a>
  <a href="Snowstorm-Swagger.html">Open Swagger &rarr;</a>
</div>