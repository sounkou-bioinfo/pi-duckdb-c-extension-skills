---
name: duckdb-c-extension-r-bindings
description: Guides packaging DuckDB C extensions with R bindings, including repository layout, installed artifacts, SQL wrappers, generated docs, and native-versus-R responsibility boundaries. Use when building or restructuring an R package around a DuckDB extension.
---

# DuckDB C Extension R Bindings

Use this skill when the extension should be usable naturally from R without turning the R package into the native core.

## Core position

A strong R integration usually keeps three things separate:

1. the native DuckDB extension
2. the installed extension artifacts bundled with the package, if applicable
3. the ergonomic R wrapper layer

The R package should expose and document the extension well, but core semantics should remain native and SQL-centered.

## Recommended layout pattern

A common practical layout is:

- `R/` for user-facing wrapper functions
- `man/` for generated docs
- `inst/duckdb_extension/` for bundled extension sources or installable artifacts when packaging that way
- `inst/extdata/` for fixtures and examples
- `inst/function_catalog/` for machine-readable/generated SQL catalog files
- `inst/tinytest/` or `tests/` for R-level tests
- top-level native extension files if the repo also builds the extension directly

Not every repo needs all of these, but the separation should stay clear.

## Main principles

### 1) Keep the native contract canonical

R helpers should mainly do things like:

- install or locate the extension
- open DuckDB connections
- call SQL functions cleanly
- validate R-specific arguments
- present results in idiomatic R shapes

Do not let R become the only specification of semantics.

### 2) Bundle artifacts intentionally

If the R package ships extension code or build artifacts:

- keep install paths explicit
- document how artifacts are refreshed
- keep vendored native code provenance visible
- do not duplicate large native trees in several places unless unavoidable

### 3) Map R names to SQL names clearly

If R exports helpers such as `pkg_feature()` that call SQL functions:

- keep the correspondence documented
- avoid silent divergence between R defaults and SQL defaults
- keep examples easy to translate back to SQL

### 4) Test the wrapper layer separately

Even if native tests pass, R can still fail via:

- argument coercion mistakes
- path handling bugs
- temporary-file behavior
- installation/layout issues
- platform-specific load/install problems

### 5) Keep documentation generation systematic

For projects with many SQL functions, a catalog-driven approach often helps generate:

- R wrapper docs
- extension function reference pages
- tables for README/pkgdown sites

## Good outcomes

- clean R ergonomics over a native core
- stable install and load paths
- low duplication of semantics
- clear docs from SQL to R

## Anti-patterns

- R wrappers that quietly redefine native semantics
- undocumented artifact copying
- no clear path from R helper to underlying SQL function
- wrapper docs drifting away from actual extension behavior

## Related skills

- [DuckDB C extension function catalog](../duckdb-c-extension-function-catalog/SKILL.md)
- [DuckDB C extension testing and interop](../duckdb-c-extension-testing-and-interop/SKILL.md)

## References

- [R package layout pattern](references/r-package-layout-pattern.md)
- [Wrapper responsibility split](references/wrapper-responsibility-split.md)
