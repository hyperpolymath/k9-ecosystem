<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk> -->
# TOPOLOGY.md — k9-rs

## Purpose

Rust parser and renderer for K9 (Self-Validating Components) specification files. K9 defines deployment contracts with security tiers (Kennel/Yard/Hunt), pedigree metadata, lifecycle recipes, and platform constraints. Provides a typed parse-render round-trip for `.k9` files.

## Module Map

```
k9-rs/
├── src/
│   ├── lib.rs         # Public crate API
│   ├── types.rs       # K9 AST types (security tiers, pedigree, recipes)
│   ├── parser.rs      # K9 document parser
│   ├── renderer.rs    # AST-to-K9 surface renderer
│   └── error.rs       # Error types
├── examples/          # Usage examples
├── Cargo.toml
└── container/         # Containerfile for CI
```

## Data Flow

```
[.k9 text] ──► [parser.rs] ──► [Typed AST] ──► [renderer.rs] ──► [.k9 text]
                                    │
                             [types.rs / error.rs]
```
