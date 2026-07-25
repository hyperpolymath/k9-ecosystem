<!--
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025-2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-->

Rust parser and renderer for K9 self-validating configuration files —
declares software components with provenance tracking, security
classification, build recipes, and runtime contracts.

# Overview

K9 is a configuration format for software component declarations. Each
component carries:

- **Pedigree** — provenance: origin URL, author, license, supply-chain
  hashes

- **SecurityLevel** — Kennel / Yard / Hunt (same three-tier model as K9
  Nickel components)

- **Recipe** — build or assembly instructions (tool + command)

- **Contracts** — runtime invariants with check commands and severity
  levels

`k9-rs` supports two surface formats:

- `.k9` — YAML-like plain-text format parsed natively

  \* `.k9.ncl` — Nickel format; detected and returned as \`K9Error  
  NickelFormat\` (requires the Nickel evaluator — use `pandoc-k9` for
  Nickel K9 files)

  == Quick Start

```rust
use k9_svc::parser::parse;
use k9_svc::renderer::render;

let input = r#"component: my-svc
  version: 0.1.0
  pedigree:
    origin: https://github.com/example/svc
    author: Alice
  security: kennel
"#;

let components = parse(input)?;
let output = render(&components)?;
```

# Security Levels

| Level | Meaning |
|----|----|
| `kennel` | Data-only. No execution. Strict sandbox. Safe to parse anywhere. |
| `yard` | Nickel evaluation + limited I/O. Capability-based sandbox. |
| `hunt` | Full shell execution via recipes. Cryptographic signature required. |

# Modules

| Module     | Purpose                                                        |
|------------|----------------------------------------------------------------|
| `types`    | `Component`, `Pedigree`, `SecurityLevel`, `Recipe`, `Contract` |
| `parser`   | `parse(str)` `→` `Vec<Component>` — detects Nickel format      |
| `renderer` | `render(&[Component])` `→` `String`                            |
| `error`    | `K9Error`: `ParseError`, `NickelFormat`, `Io`, `RenderError`   |

# Related

- [k9-haskell](https://github.com/hyperpolymath/k9-haskell) — Haskell
  implementation

- [pandoc-k9](https://github.com/hyperpolymath/pandoc-k9) — Pandoc
  reader/writer for `.k9.ncl` files

# License

MPL-2.0 (MPL-2.0 preferred; MPL-2.0 required for crates.io). See
[LICENSE](LICENSE).
