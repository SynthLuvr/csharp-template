# C# Template

A minimal .NET project template with a complete build, format, lint, and
test toolchain. The code does nothing useful — it’s a starting point for
new projects.

## Tech Stack

| Tool | Purpose |
|----|----|
| [.NET 10 SDK](https://dotnet.microsoft.com) | Build + type-check (Roslyn) |
| [NuGet + CPM](https://learn.microsoft.com/nuget/consume-packages/Central-Package-Management) | Package manager (central versions) |
| [CSharpier](https://csharpier.com) | Opinionated code formatter |
| [dotnet format](https://learn.microsoft.com/dotnet/core/tools/dotnet-format) | Style + analyzer fixes |
| [Roslynator](https://github.com/dotnet/roslynator) / [StyleCop](https://github.com/DotNetAnalyzers/StyleCopAnalyzers) | Type-aware analyzers |
| [ast-grep](https://ast-grep.github.io) | Structural lint rules |
| [TUnit](https://thomhurst.github.io/TUnit) | Test runner (source-generated) |
| [just](https://github.com/casey/just) | Script orchestration |
| [pandoc](https://pandoc.org) | Markdown formatter (GFM) |

## Prerequisites

- [.NET 10 SDK](https://dotnet.microsoft.com) (pinned in `global.json`)
- [just](https://github.com/casey/just) — a command runner
- [CSharpier](https://csharpier.com) 1.3.0 —
  `dotnet tool install -g csharpier --version 1.3.0`
- [ast-grep](https://ast-grep.github.io) 0.51.0 —
  `npm install -g @ast-grep/cli@0.51.0`
- [pandoc](https://pandoc.org) \>= 3.2 — required by `just lint-md` /
  `just format-md`

## Quick Start

``` bash
dotnet restore
just build    # type-check + compile (Roslyn)
just test     # run unit tests (TUnit)
```

## Scripts

All tasks live in the `justfile` and run with `just <recipe>`.

### Build

| Recipe       | Description                              |
|--------------|------------------------------------------|
| `just build` | Type-check and compile with the .NET SDK |

### Lint

`just lint` runs every linter in sequence:

| Recipe                | Description                            |
|-----------------------|----------------------------------------|
| `just lint-csharpier` | Verify code is CSharpier-formatted     |
| `just lint-dotnet`    | `dotnet format --verify-no-changes`    |
| `just lint-structure` | ast-grep structural rules              |
| `just lint-md`        | pandoc: Markdown must be GFM-formatted |

### Format

`just format` runs every formatter in sequence:

| Recipe                  | Description                                  |
|-------------------------|----------------------------------------------|
| `just format-csharpier` | Apply CSharpier formatting (code + XML)      |
| `just format-dotnet`    | Apply `dotnet format` style + analyzer fixes |
| `just format-md`        | Reformat Markdown to canonical GFM           |

### Test

| Recipe            | Description    |
|-------------------|----------------|
| `just test`       | Run unit tests |
| `just test-watch` | Watch mode     |

## Coding Conventions

These are **enforced** by the toolchain, not just preferences:

- **Expression-bodied members** for single-line methods/properties
  (`.editorconfig`, enforced as errors — the C# analogue of the TS
  template’s “arrow functions only”)
- **File-scoped namespaces** (`.editorconfig`, enforced)
- **Braces omitted** for single statements (`.editorconfig`)
- **Analyzers as errors** — `TreatWarningsAsErrors` with Roslynator +
  StyleCop + the .NET analyzers
- **Central Package Management** — all versions pinned in
  `Directory.Packages.props`
- **CSharpier** owns whitespace/layout; double quotes, 4-space indent
- **Markdown via pandoc** — all `.md` formatted with `pandoc -t gfm`

## Project Structure

    ├── .ast-grep/rules/        # Structural lint rules
    ├── .github/workflows/      # CI
    ├── scripts/                # Tooling scripts (pandoc-md)
    ├── src/                    # Library code (replace with your own)
    ├── tests/                  # Unit tests
    ├── .editorconfig           # Format + style + analyzer config
    ├── Directory.Build.props   # Shared MSBuild props (analyzers, errors)
    ├── Directory.Packages.props # Central Package Management (versions)
    ├── global.json             # .NET SDK + test runner pin
    └── justfile                # All build/lint/test/format tasks
