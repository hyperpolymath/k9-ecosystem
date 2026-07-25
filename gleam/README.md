<!--
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025-2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-->

**K9 parser and renderer for Gleam — compiles to BEAM and JavaScript.**

[![License: MPL-2.0](https://img.shields.io/badge/License-MPL_2.0-blue.svg)](https://opensource.org/licenses/MPL-2.0)
![Gleam](https://img.shields.io/badge/language-Gleam-pink.svg) ![BEAM +
JS](https://img.shields.io/badge/targets-BEAM%20%2B%20JS-green.svg)

# What this is

`k9_gleam` is the Gleam implementation of the K9 configuration format.
K9 is a self-validating component specification format with three
graduated security levels: **Kennel** (data), **Yard** (contracts),
**Hunt** (execution).

Because Gleam compiles to both Erlang bytecode (BEAM) and JavaScript,
this single library works in Elixir/Erlang projects, Deno scripts, and
browser applications — from the same source.

# Quick start

Add to `gleam.toml`:

```toml
[dependencies]
k9_gleam = ">= 0.1.0"
```

Then:

```gleam
import k9

case k9.parse(content) {
  Ok(doc) -> io.debug(doc)
  Error(err) -> io.println("Parse error: " <> err.message)
}
```

# Cross-compilation

```bash
# Build for BEAM (Erlang/Elixir)
gleam build

# Build for JavaScript (Deno, Node, browser)
gleam build --target javascript

# Run tests on both targets
gleam test
```

Both produce identical behaviour — no platform-specific code paths.

# Module layout

| Module | Purpose |
|----|----|
| `src/k9/parser.gleam` | Recursive descent parser: `parse(String)` `→` `Result(Document,` `ParseError)` |
| `src/k9/types.gleam` | K9 type system: `Document`, `Value`, `Key`, `Type`, `Metadata` |
| `src/k9/validation.gleam` | Post-parse validation: duplicate keys, type consistency |
| `src/k9.gleam` | Public API: `parse/1`, `render/1`, `validate/1` |
| `test/` | Test suite exercised on both BEAM and JS targets |

# K9 security levels

| Level | What it permits |
|----|----|
| **Kennel** (`.k9`) | Pure data. Safe to process from any source. |
| **Yard** (`.k9.ncl`, unevaluated) | Nickel contracts for typed validation. No shell access. |
| **Hunt** (`.k9.ncl`, signed) | Executable recipes. Requires a valid cryptographic signature. |

# K9 ecosystem

- [k9-rs](https://github.com/hyperpolymath/k9-rs) — Rust (reference
  implementation)

- [k9_ex](https://github.com/hyperpolymath/k9_ex) — Elixir

- [k9-haskell](https://github.com/hyperpolymath/k9-haskell) — Haskell

- [tree-sitter-k9](https://github.com/hyperpolymath/tree-sitter-k9) —
  Editor grammar

See <a href="EXPLAINME.adoc" class="adoc">EXPLAINME</a> for
implementation evidence and caveats.

# License

This project is licensed under the Mozilla Public License, v. 2.0. See
the `LICENSE` file for details.

SPDX-License-Identifier: CC-BY-SA-4.0

# Author

Jonathan D.A. Jewell\
[j.d.a.jewell@open.ac](j.d.a.jewell@open.ac).uk
