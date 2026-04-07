---
layout: default
title: ApiResult Monad - Union Types in C# 15
---

<div class="lecture-menu">
  <a href="ApiResultMonad-UnionTypes.html" aria-current="page">1. Union Types</a>
  <a href="ApiResultMonad-Introduction.html">2. Introduction</a>
  <a href="ApiResultMonad-MapAndBind.html">3. Map &amp; Bind</a>
  <a href="ApiResultMonad-FullExample.html">4. Full Example &amp; Setup</a>
</div>

# Union Types in C# 15

Before diving into the `ApiResult<T>` monad, it helps to understand the building block it relies on: **C# 15 union types**.

---

## What Is a Union Type?

A union type is a type that holds **exactly one of several named cases** at a time. No inheritance, no wrapper objects, no `object` boxing — just a closed set of possibilities that the compiler knows about at every switch site.

This is sometimes called a **discriminated union** (the term used in F#) or an **algebraic data type** (Haskell/Rust). C# 15 brings this as a first-class language feature.

---

## C# 15 Syntax

```csharp
public union IntOrBool(int i, bool b);
```

That single line declares a type that can be either an `int` or a `bool`. Each member (`i`, `b`) is a **case** — its name is used in pattern matching and conversions.

You can add methods to the body just like a regular type:

```csharp
public union IntOrBool(int i, bool b)
{
    public readonly bool AsBool() => this switch
    {
        int i  => i != 0,
        bool b => b,
        null   => throw new UnreachableException()
    };

    public readonly int AsInt() => this switch
    {
        int i  => i,
        bool b => b ? 1 : 0,
        null   => throw new UnreachableException()
    };

    public override string ToString() => this switch
    {
        int i  => $"Integer: {i}",
        bool b => $"bool: {b}",
        null   => throw new UnreachableException()
    };
}
```

---

## What Is New in C# 15 Here?

| Feature | Detail |
|---|---|
| `union` keyword | Declares a closed discriminated union type |
| Primary-parameter syntax | `(int i, bool b)` lists the cases inline |
| Implicit conversions | Assigning an `int` or `bool` directly to `IntOrBool` just works |
| Exhaustive pattern matching | `switch` on a union must cover every declared case |
| Reassignment across cases | The same variable can hold a different case after reassignment |
| `null` arm | The compiler may emit a `null` arm; guard with `UnreachableException` |
| Method bodies | Full method and property support inside the union body |

Union types are value-type-like in semantics — they are **closed** (no external subclassing) and **exhaustive** (every case is known at compile time).

---

## Usage — Reassignment Across Cases

One of the most practical aspects of union types is that a single variable can be **reassigned** to hold a different case. The variable keeps the declared union type; only the runtime case changes:

```csharp
IntOrBool intOrBool = 42;   // holds an int case
Console.WriteLine(intOrBool);           // "Integer: 42"
Console.WriteLine(intOrBool.AsBool());  // false  (0 == false)
Console.WriteLine(intOrBool.AsInt());   // 42

intOrBool = true;           // reassigned — now holds a bool case
Console.WriteLine(intOrBool);           // "bool: True"
Console.WriteLine(intOrBool.AsBool());  // true
Console.WriteLine(intOrBool.AsInt());   // 1
```

No cast, no new wrapper, no type mismatch — the implicit conversion handles it. This is what makes union types ergonomic compared to class hierarchies or `OneOf<>` libraries.

---

## Pattern Matching

Use a `switch` expression to branch on the current case. The compiler enforces that **all cases are handled**:

```csharp
string Describe(IntOrBool value) => value switch
{
    int i  => $"It's an integer: {i}",
    bool b => $"It's a boolean: {b}",
    null   => throw new UnreachableException()
};
```

If you drop a case the compiler will warn (or error, depending on settings): exhaustiveness is checked statically.

---

## Source

The `IntOrBool` example is from the [UnionTypesDemo1](https://github.com/toreaurstadboss/UnionTypesDemo1/commit/3b0550f7fca76fba1e4648ed424c9d7b69468922) repository.

---

## Why This Matters for Monads

The `ApiResult<T>` monad you'll see next relies on exactly this mechanism — a union type with three cases (`Success<T>`, `HttpError`, `TransportError`) — to represent every possible outcome of an HTTP call in a single, safe, pattern-matchable type.

<div class="lecture-pager">
  <a href="ApiResultMonad.html">← Back to index</a>
  <a href="ApiResultMonad-Introduction.html">Introduction →</a>
</div>
