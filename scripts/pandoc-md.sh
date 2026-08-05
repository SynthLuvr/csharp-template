#!/usr/bin/env bash
#
# Pandoc lint/format for Markdown files (GitHub-Flavored Markdown).
# Mirrors the TS template's scripts/pandoc-md.mts.
#
#   ./scripts/pandoc-md.sh --check   read-only; exits 1 on drift
#   ./scripts/pandoc-md.sh --write   overwrites each file with pandoc output
#
# Every tracked *.md file must be byte-for-byte identical to the output of
# `pandoc <file> -t gfm`, making pandoc the single source of truth for Markdown
# formatting. Requires `pandoc` (>= 3.1) on PATH.
set -euo pipefail

mode="${1:-}"
if [[ "$mode" != "--check" && "$mode" != "--write" ]]; then
  echo "usage: scripts/pandoc-md.sh --check | --write" >&2
  exit 2
fi

if ! command -v pandoc >/dev/null 2>&1; then
  echo "pandoc was not found on PATH. Install pandoc (>= 3.1) and retry." >&2
  exit 1
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mapfile -t files < <(find "$root" -name '*.md' \
  -not -path '*/.git/*' -not -path '*/bin/*' -not -path '*/obj/*' \
  -not -path '*/node_modules/*' | sort)

drifted=()
for file in "${files[@]}"; do
  tmp="$(mktemp)"
  if ! pandoc "$file" -t gfm >"$tmp"; then
    rm -f "$tmp"
    exit 1
  fi
  if cmp -s "$file" "$tmp"; then
    rm -f "$tmp"
    continue
  fi
  rel="${file#"$root/"}"
  if [[ "$mode" == "--write" ]]; then
    cp "$tmp" "$file"
    rm -f "$tmp"
    echo "formatted $rel"
  else
    rm -f "$tmp"
    drifted+=("$rel")
  fi
done

if [[ "$mode" == "--check" ]]; then
  if (( ${#drifted[@]} > 0 )); then
    echo "Markdown files are not pandoc-formatted:" >&2
    printf '  %s\n' "${drifted[@]}" >&2
    echo -e "\nFix with: just format-md" >&2
    exit 1
  fi
  echo "pandoc check passed for ${#files[@]} markdown file(s)."
fi
