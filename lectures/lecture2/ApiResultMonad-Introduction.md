---
layout: default
title: ApiResult Monad - Introduction
---

<div class="lecture-menu">
  <a href="ApiResultMonad-Introduction.html" aria-current="page">1. Introduction</a>
  <a href="ApiResultMonad-MapAndBind.html">2. Map &amp; Bind</a>
  <a href="ApiResultMonad-FullExample.html">3. Full Example &amp; Setup</a>
</div>

# Introduction

## What are Monads?

A monad is a design pattern from functional programming. Think of it as a **smart wrapper** around a value that lets you chain operations without checking for errors at every step. The wrapper carries the result or the failure through the pipeline — you only handle the outcome at the end.

Classic examples: `Option<T>` (maybe a value), `Result<T, E>` (success or error). `ApiResult<T>` is a result monad tailored for HTTP calls.

---

## C# 15 Union Types

C# 15 introduces **union types** (discriminated unions): a type that holds exactly one of several defined cases.

```csharp
public readonly union ApiResult<T>(
    Success<T> success,
    HttpError httpError,
    TransportError transportLevelError
);
```

This replaces inheritance hierarchies or `OneOf<>` libraries with first-class language support. The compiler knows all possible cases, so pattern matching is **exhaustive and clean**.

Union types are the key enabler — they let us do functional-style result chaining in idiomatic C#.

---

## The Three Cases

| Case | Meaning |
|---|---|
| `Success<T>` | HTTP 2xx + valid deserialized body |
| `HttpError` | HTTP 4xx/5xx response |
| `TransportError` | Socket/network/timeout exceptions |

Every `ApiResult<T>` is exactly one of these three — no nulls, no exceptions leaking out.

<div class="lecture-pager">
  <a href="ApiResultMonad.html">← Back to index</a>
  <a href="ApiResultMonad-MapAndBind.html">Map &amp; Bind →</a>
</div>
