---
layout: default
title: ApiResult Monad - Full Example & Setup
---

<div class="lecture-menu">
  <a href="ApiResultMonad-UnionTypes.html">1. Union Types</a>
  <a href="ApiResultMonad-Introduction.html">2. Introduction</a>
  <a href="ApiResultMonad-MapAndBind.html">3. Map &amp; Bind</a>
  <a href="ApiResultMonad-FullExample.html" aria-current="page">4. Full Example &amp; Setup</a>
</div>

# Full Example &amp; Setup

## Consuming a Result

At the edge of your pipeline, use a `switch` expression to exhaustively handle all three cases:

```csharp
var output = result.Value switch
{
    Success<Todo> s  => $"OK: {s.Data.Title}",
    HttpError h      => $"HTTP {h.StatusCode}: {h.Message}",
    TransportError t => $"Transport error: {t.Exception.Message}",
    _                => "Unknown"
};
```

The compiler enforces exhaustiveness — you cannot forget a case.

---

## Full Example — Fetch, Transform, Chain

```csharp
var result = await httpClient.GetJsonAsync<Todo>("https://api.example.com/todos/1");

var summary = await result
    .MapAsync(async todo => todo with { Title = todo.Title.ToUpperInvariant() })
    .ContinueWith(t => t.Result.Bind(todo =>
        todo.Completed
            ? ApiResult.Ok($"Done: {todo.Title}")
            : ApiResult.HttpFail<string>(HttpStatusCode.UnprocessableEntity, "Not completed")));

Console.WriteLine(summary.Value switch
{
    Success<string> s => s.Data,
    HttpError h       => $"Error {h.StatusCode}: {h.Message}",
    TransportError t  => $"Transport: {t.Exception.Message}",
    _                 => "?"
});
```

## `GetJsonAsync` Extension

`RemoteServiceExtensions.GetJsonAsync<T>` wraps an `HttpClient` call and returns `ApiResult<T>` — HTTP errors and exceptions are handled transparently:

```csharp
var result = await httpClient.GetJsonAsync<Todo>(url);
```

No try/catch needed at the call site. Errors flow through the monad.

---

## Requirements &amp; Setup

| | |
|---|---|
| IDE | VS Code Insiders |
| Extensions | C# Dev Kit + C# — both set to **Preview** channel |
| Target framework | `net11.0` (Update 2) |
| Language version | `<LangVersion>preview</LangVersion>` in `.csproj` |

Union types are a **C# 15 preview feature**. The `preview` lang version and preview extension channels are required for compiler support.

### Enable Preview Extensions in VS Code Insiders

1. Open Extensions (`Ctrl+Shift+X`)
2. Find **C#** → gear icon → *Switch to Pre-Release Version*
3. Find **C# Dev Kit** → gear icon → *Switch to Pre-Release Version*

### Github repo

Source code and tests are available at:
[github.com/toreaurstadboss/ApiResultMonad](https://github.com/toreaurstadboss/ApiResultMonad){:target="_blank"}

<div class="lecture-pager">
  <a href="ApiResultMonad-MapAndBind.html">← Map &amp; Bind</a>
  <a href="ApiResultMonad.html">Back to index →</a>
</div>
