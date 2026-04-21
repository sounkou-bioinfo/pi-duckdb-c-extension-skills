# Changelog

## 0.2.0

- Added `LICENSE`.
- Added install-test snippets to `README.md`.
- Added `functions.example.yaml` and `generate-function-catalog.sh` as minimal function-catalog references.
- Added a DuckTinyCC case study covering use of `access->get_database(info)` and an extension-managed persistent connection during extension init.
- Expanded the R-bindings skill with the README.Rmd + custom knitr SQL engine documentation pattern used in DuckTinyCC and DuckHTS, with a generic example.

## 0.1.0

- Initial release.
- Added skills for DuckDB C extension architecture, vendoring, API stability, R bindings, function catalogs, and testing/interop.
- Distilled generic patterns inspired by projects such as DuckHTS and DuckTinyCC without tying the guidance to one domain.
