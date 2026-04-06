---
layout: default
title: ApiResult Monad - Map & Bind
---

<div class="lecture-menu">
  <a href="ApiResultMonad-Introduction.html">1. Introduction</a>
  <a href="ApiResultMonad-MapAndBind.html" aria-current="page">2. Map &amp; Bind</a>
  <a href="ApiResultMonad-FullExample.html">3. Full Example &amp; Setup</a>
</div>

# Map &amp; Bind

## Map — Transform the Value

`Map` applies a function to the inner value **if it is a success**. Errors pass through unchanged — you stay on the "happy rail".

```csharp
// Sync
ApiResult<string> title = ApiResult.Ok(todo)
    .Map(t => t.Title.ToUpperInvariant());

// Async
ApiResult<string> title = await ApiResult.Ok(todo)
    .MapAsync(async t => await EnrichTitleAsync(t.Title));
```

Use `Map` when transforming data without introducing new failure cases.

---

## Bind — Chain Operations

`Bind` (flatMap) sequences operations where **each step can itself fail**. It unwraps the value and passes it to a function that returns a new `ApiResult<TResult>`, preventing nested `ApiResult<ApiResult<T>>`.

```csharp
// Sync
ApiResult<string> result = ApiResult.Ok(42)
    .Bind(id => id > 0
        ? ApiResult.Ok(id.ToString())
        : ApiResult.HttpFail<string>(HttpStatusCode.BadRequest, "Invalid id"));

// Async
ApiResult<string> result = await ApiResult.Ok(42)
    .BindAsync(async id => await FetchUserAsync(id));
```

Use `Bind` when the next operation can also fail.

---

## Map vs Bind — at a glance

| | Input | Output |
|---|---|---|
| `Map` | `T` | `TResult` (transform only) |
| `Bind` | `T` | `ApiResult<TResult>` (can fail) |

<div class="lecture-pager">
  <a href="ApiResultMonad-Introduction.html">← Introduction</a>
  <a href="ApiResultMonad-FullExample.html">Full Example &amp; Setup →</a>
</div>
