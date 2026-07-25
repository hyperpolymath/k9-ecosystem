<!--
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025-2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-->

Haskell library for parsing and rendering K9 self-validating
configuration components — Hackage-ready, purely functional, typed AST.

# Overview

K9 is a configuration format for software component declarations with
built-in provenance tracking, security classification, build recipes,
and runtime contracts. `k9-haskell` provides a purely functional parser
and renderer for both K9 surface formats:

- `.k9` — YAML-like plain-text format, identified by the `K9!` magic
  number

- `.k9.ncl` — Nickel format; detected and parsed via `parseK9Nickel`

The library exports typed Haskell data structures: `Component`,
`Pedigree`, `SecurityLevel`, `SecurityPolicy`, `Target`, `Recipes`,
`Validation`, `Contract`, `ContractClause`.

# Security Levels

| Level    | Meaning                                              |
|----------|------------------------------------------------------|
| `Kennel` | Pure data. No code execution. Safe to open anywhere. |
| `Yard`   | Controlled execution with limited permissions.       |
| `Hunt`   | Full execution. Explicit authorisation required.     |

`SecurityPolicy` wraps the level with explicit permission flags, so a
`Yard`-level component can carry fine-grained capability declarations
beyond the three-tier classification.

# Usage

```haskell
import Data.K9 (parseK9, render)

main :: IO ()
main = do
  txt <- readFile "component.k9"
  case parseK9 txt of
    Left err  -> putStrLn $ "Parse error: " <> show err
    Right cmp -> putStrLn $ render cmp
```

# Format Detection

```haskell
import Data.K9.Parser (detectFormat, K9Format(..))

-- Returns K9Yaml or K9Nickel based on file content
fmt <- detectFormat <$> readFile "component.k9.ncl"
```

# Modules

| Module | Purpose |
|----|----|
| `Data.K9` | Top-level re-export |
| `Data.K9.Types` | All AST types |
| `Data.K9.Parser` | `parseK9`, `parseK9File`, `parseK9Nickel`, `detectFormat` |
| `Data.K9.Renderer` | `render` `::` `Component` `→` `Text` |

# Related

- [k9-rs](https://github.com/hyperpolymath/k9-rs) — Rust implementation

- [pandoc-k9](https://github.com/hyperpolymath/pandoc-k9) — Pandoc Lua
  reader/writer for `.k9.ncl`

# Building

```sh
cabal build
cabal test
```

# License

MPL-2.0 (MPL-2.0 preferred; MPL-2.0 required for Hackage). See
[LICENSE](LICENSE).
