# AGENTS.md

Instructions for AI coding agents working in this repository.

## Quick Start

``` bash
dotnet restore
just build    # type-check with Roslyn
just test     # run tests
just lint     # run all linters
```

## Required Workflow

Always run these before considering work complete:

``` bash
just build && just lint && just test
```

All three must pass with zero errors.

## Coding Conventions (Enforced)

These are **not** preferences — the toolchain will fail if you violate
them:

### Expression-bodied members

Use expression-bodied members (`=>`) for single-line methods and
properties.

``` csharp
// Wrong
public string Greet()
{
    return "hello";
}

// Right
public string Greet() => "hello";
```

### File-scoped namespaces

``` csharp
// Wrong
namespace CSharpTemplate
{
    public class Foo { }
}

// Right
namespace CSharpTemplate;

public class Foo { }
```

### Analyzers are errors

Every analyzer and code-style warning is a compile error
(`TreatWarningsAsErrors` in `Directory.Build.props`). Fix the root cause
rather than suppressing. Roslynator, StyleCop, and the .NET analyzers
all run on build.

### Central Package Management

Add or update package versions **only** in `Directory.Packages.props`.
Reference packages in `.csproj` files **without** a `Version` attribute.

### Formatting

If the linter complains about formatting, run:

``` bash
just format
```

This runs, in order:

1.  `csharpier format .` — opinionated code and XML formatting
2.  `dotnet format` — applies `.editorconfig` style and analyzer
    code-fixes
3.  `format-md` — pandoc Markdown formatting

## Formatting Conventions

- Double quotes, 4-space indentation
- Expression-bodied members for single-line methods
- File-scoped namespaces
- Braces omitted for single statements
- Markdown via pandoc (GFM)

## Project Structure

- Source code lives in `src/`
- Tests live in `tests/` (TUnit; filenames end in `Tests.cs`)
- Shared MSBuild props: `Directory.Build.props`,
  `Directory.Packages.props`
- `justfile` defines all tasks; `global.json` pins the SDK and test
  runner
