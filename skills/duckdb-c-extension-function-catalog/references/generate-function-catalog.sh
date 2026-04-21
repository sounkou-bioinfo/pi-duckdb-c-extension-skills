#!/usr/bin/env bash
set -euo pipefail

# Minimal generator stub for a functions.yaml-style catalog.
# Usage:
#   ./generate-function-catalog.sh functions.example.yaml outdir

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <functions.yaml> <outdir>" >&2
  exit 1
fi

INPUT="$1"
OUTDIR="$2"
mkdir -p "$OUTDIR"

python3 - "$INPUT" "$OUTDIR" <<'PY'
import sys
from pathlib import Path
try:
    import yaml
except Exception as e:
    raise SystemExit(f"python3 with PyYAML is required: {e}")

inp = Path(sys.argv[1])
outdir = Path(sys.argv[2])
data = yaml.safe_load(inp.read_text())
funcs = data.get("functions", [])

md_lines = ["# Function Catalog", "", "This file is generated from the catalog source.", "", "| name | kind | returns | since | deprecated | description |", "|---|---|---|---|---|---|"]
tsv_lines = ["name\tkind\treturns\tsince\tdeprecated\tdescription"]

for f in funcs:
    dep = f.get("deprecated")
    dep_text = ""
    if isinstance(dep, dict):
        dep_text = dep.get("since", "")
    desc = (f.get("description") or "").replace("|", "\\|").replace("\t", " ")
    md_lines.append(f"| {f.get('name','')} | {f.get('kind','')} | {f.get('returns','')} | {f.get('since','')} | {dep_text} | {desc} |")
    tsv_lines.append("\t".join([
        f.get("name", ""),
        f.get("kind", ""),
        f.get("returns", ""),
        f.get("since", ""),
        dep_text,
        (f.get("description") or "").replace("\t", " ").replace("\n", " "),
    ]))

(outdir / "functions.md").write_text("\n".join(md_lines) + "\n")
(outdir / "functions.tsv").write_text("\n".join(tsv_lines) + "\n")
print(f"wrote {outdir / 'functions.md'}")
print(f"wrote {outdir / 'functions.tsv'}")
PY
