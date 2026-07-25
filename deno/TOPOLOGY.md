<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk> -->
# TOPOLOGY.md — k9-deno

## Purpose

Deno-native parser and renderer for K9 (Self-Validating Components) specification files, written in ReScript and compiled to JavaScript ES modules. Handles `.k9` files with security tiers (Kennel/Yard/Hunt), pedigree metadata, lifecycle recipes, and deployment contracts. Published to JSR.

## Module Map

```
k9-deno/
├── src/
│   ├── k9/               # K9 parser module
│   │   ├── K9_Parser.res
│   │   └── (compiled .mjs co-located)
│   └── (core, errors, aspects, bridges, contracts, definitions)
├── examples/             # Usage examples
├── deno.json             # Deno module config
├── jsr.json              # JSR publication config
└── container/            # Containerfile for CI
```

## Data Flow

```
[.k9 text] ──► [K9_Parser] ──► [Typed AST] ──► [K9_Renderer] ──► [.k9 text]
```
