<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk> -->
# TOPOLOGY.md — k9-haskell

## Purpose

Haskell implementation of the K9 (Self-Validating Components) parser and renderer. Uses algebraic data types for precise modelling of security tiers, pedigree metadata, and deployment contracts. Targets template validators, Scaffoldia, and other type-heavy Haskell tooling.

## Module Map

```
k9-haskell/
├── src/
│   ├── Data/             # K9 AST data types (Haskell ADTs)
│   ├── interface/        # Public API surface
│   └── (core, errors, aspects)
├── bench/                # Benchmarks
├── examples/             # Usage examples
├── k9-haskell.cabal      # Cabal build config
└── container/            # Containerfile for CI
```

## Data Flow

```
[.k9 text] ──► [Parser] ──► [Haskell ADT AST] ──► [Renderer] ──► [.k9 text]
```
