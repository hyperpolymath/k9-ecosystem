<!--
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025-2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-->

# Overview

**Deno-native parser library for K9 (Self-Validating Components),
written in ReScript.**

K9 is a specification format for self-validating software components
with built-in pedigree metadata, security levels (Kennel/Yard/Hunt),
target platform constraints, lifecycle recipes, and deployment
contracts. This library provides a complete parser and renderer for .k9
specification files, compiled from ReScript to JavaScript ES modules for
use with Deno.

# Features

- Parse K9 component specifications from strings or files

- Render AST back to .k9 YAML-like format (round-trip support)

- Security level hierarchy: Kennel (pure data), Yard (controlled), Hunt
  (full execution)

- Pedigree metadata with provenance tracking

- Target platform constraints (OS, edge, Podman, memory)

- Lifecycle recipes (install, validate, deploy, migrate, custom)

- Self-validation blocks (checksum, pedigree version)

- Format detection (YAML-like .k9 vs Nickel .k9.ncl)

- Zero dependencies beyond ReScript standard library

# Quick Start

```bash
# Build ReScript to JS
deno task build

# Use in your Deno project
deno add jsr:@hyperpolymath/k9
```

```javascript
import { parse, render, parseErrorToString } from "@hyperpolymath/k9";

const result = parse(`K9!
---
metadata:
  name: hello-k9
  version: 0.1.0
  description: A simple K9 component
security:
  trust_level: 'Kennel
  allow_network: false
  allow_filesystem_write: false
  allow_subprocess: false
`);
// result is Ok(component) or Error(parseError)
```

# Module Structure

| Module | Purpose |
|----|----|
| `K9.res` | Main module — re-exports all public API |
| `K9_Types.res` | Core data types: component, pedigree, securityLevel, target, recipes, validation, contract |
| `K9_Parser.res` | Line-oriented parser: .k9 text to typed AST |
| `K9_Renderer.res` | Renderer: typed AST back to .k9 text |

# K9 Format Reference

```yaml
K9!
---
metadata:
  name: my-component
  version: 1.0.0
  description: A self-validating component
  author: Jonathan D.A. Jewell
  license: MPL-2.0

security:
  trust_level: 'Yard
  allow_network: true
  allow_filesystem_write: false
  allow_subprocess: false

target:
  os: Linux
  is_edge: false
  requires_podman: true
  memory: 512M

recipes:
  install: deno install
  validate: deno task test
  deploy: deno task deploy

validation:
  checksum: sha256:abc123...
  pedigree_version: 1.0
  hunt_authorized: false

tags:
  - deno
  - rescript
  - parser
```

## Security Levels

| Level | Permissions | Use Case |
|----|----|----|
| `’Kennel` | No execution, no network, no filesystem, no subprocess | Pure data, configuration, static assets |
| `’Yard` | Controlled execution, network allowed | Services, APIs, constrained tools |
| `’Hunt` | Full execution, all permissions | Build tools, deployment scripts, system administration |

# Development

```bash
deno task build    # Compile ReScript
deno task clean    # Clean build artifacts
deno task test     # Run tests
```

# Related Libraries

- [k9-rs](https://github.com/hyperpolymath/k9-rs) — Rust implementation

- [k9-haskell](https://github.com/hyperpolymath/k9-haskell) — Haskell
  implementation

- [k9_gleam](https://github.com/hyperpolymath/k9_gleam) — Gleam
  implementation

- [tree-sitter-k9](https://github.com/hyperpolymath/tree-sitter-k9) —
  Tree-sitter grammar

- [vscode-k9](https://github.com/hyperpolymath/vscode-k9) — VS Code
  extension

# License

SPDX-License-Identifier: CC-BY-SA-4.0

Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath)

See [LICENSE](LICENSE) for details.
