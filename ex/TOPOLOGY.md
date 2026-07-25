<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk> -->
# TOPOLOGY.md — k9_ex

## Purpose

Elixir implementation of the K9 (Self-Validating Components) parser and renderer. Provides K9 contract validation and pedigree extraction for BEAM/Phoenix applications. Supports the `.k9` and `.k9.ncl` formats with security-tier enforcement.

## Module Map

```
k9_ex/
├── lib/
│   ├── k9/
│   │   ├── core/         # Parser core
│   │   ├── errors/       # Error structs
│   │   └── (aspects, bridges, contracts, definitions, interface)
│   └── k9.ex             # Top-level module entry point
├── mix.exs               # Mix project config
└── deps/                 # Dependencies
```

## Data Flow

```
[.k9 text] ──► [K9.Parser] ──► [Typed structs] ──► [K9.Renderer] ──► [.k9 text]
```
