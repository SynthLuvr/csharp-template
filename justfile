# Resolve `dotnet` and `csharpier` from the default ~/.dotnet install location
# (a fresh WSL shell rc won't have added it to PATH). DOTNET_ROOT lets
# global-tool apphosts locate the runtime without /etc/dotnet/install_location.
home := env_var_or_default("HOME", "")
export PATH := home + "/.dotnet:" + home + "/.dotnet/tools:" + env_var("PATH")
export DOTNET_ROOT := env_var_or_default("DOTNET_ROOT", home + "/.dotnet")

# Default: list available recipes.
default:
    @just --list

# Restore NuGet packages (versions pinned via Central Package Management).
install:
    dotnet restore

# Type-check + compile. Analyzers and code style are enforced as errors.
build:
    dotnet build

# Run the unit tests (TUnit, via Microsoft.Testing.Platform).
test:
    dotnet test

# Re-run the tests whenever a file changes.
test-watch:
    dotnet watch test

# Verify code is CSharpier-formatted (CI gate). No changes written.
lint-csharpier:
    csharpier check .

# Verify no pending dotnet format style/analyzer fixes (CI gate).
lint-dotnet:
    dotnet format --verify-no-changes

# Structural lint rules via ast-grep (e.g. no top-of-file comments).
lint-structure:
    #!/usr/bin/env bash
    set -euo pipefail
    shopt -s nullglob
    for rule in .ast-grep/rules/*.yml; do
        name="$(basename "$rule" .yml)"
        ast-grep scan --rule "$rule" --error="$name" \
            --globs '!**/obj/**' --globs '!**/bin/**' .
    done

# Markdown must be canonical GitHub-Flavored (pandoc).
lint-md:
    ./scripts/pandoc-md.sh --check

# All linters (mirrors the TS template's `pnpm lint`).
lint: lint-csharpier lint-dotnet lint-structure lint-md

# Apply CSharpier formatting (code + XML).
format-csharpier:
    csharpier format .

# Apply dotnet format style + analyzer code-fixes.
format-dotnet:
    dotnet format

# Reformat Markdown to canonical GFM.
format-md:
    ./scripts/pandoc-md.sh --write

# All formatters (mirrors the TS template's `pnpm format`).
format: format-csharpier format-dotnet format-md

# Full local CI check.
ci: build test lint
