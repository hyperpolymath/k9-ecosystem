<!--
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025-2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-->

**K9 parser and renderer for Elixir/BEAM.**

![License:
MPL-2.0](https://img.shields.io/badge/License-MPL--2.0-blue.svg)
![Elixir](https://img.shields.io/badge/language-Elixir-blueviolet.svg)
![K9](https://img.shields.io/badge/format-K9-green.svg)

# What this is

`k9_ex` is the Elixir implementation of the K9 configuration format
parser and renderer. K9 is a self-validating component specification
format with three graduated security levels: **Kennel** (data), **Yard**
(contracts), **Hunt** (execution).

This library parses `.k9` files into a typed Elixir AST and round-trips
the AST back to K9 surface syntax.

# Quick start

Add to `mix.exs`:

```elixir
defp deps do
  [
    {:k9_ex, "~> 0.1.0"}
  ]
end
```

Then:

```elixir
# Parse a K9 file
{:ok, component} = K9.Parser.parse(File.read!("my-component.k9"))

# Inspect the pedigree
component.pedigree.name    # => "my-component"
component.security.level   # => :kennel

# Round-trip back to K9 syntax
rendered = K9.Renderer.render(component)
```

# Architecture

| Module | Purpose |
|----|----|
| `K9.Parser` (`lib/k9/parser.ex`) | Reads `.k9` text → typed `Component` struct. Splits by section (pedigree, security, target, recipes, validation), extracts key-value pairs. |
| `K9.Renderer` (`lib/k9/renderer.ex`) | Reconstructs K9 surface syntax from a `Component` struct. |
| `K9.Types` (`lib/k9/types.ex`) | Elixir structs: `Component`, `Pedigree`, `SecurityPolicy`, `Target`, `Recipes`, `Validation`. |
| `K9` (`lib/k9.ex`) | Public API — re-exports `parse/1`, `render/1`. |
| `test/k9_test.exs` | Round-trip tests, section extraction, error handling. |

# K9 security levels

| Level | What it permits |
|----|----|
| **Kennel** (`:kennel`) | Pure data. Safe to process from any source. Equivalent to `Cargo.toml`. |
| **Yard** (`:yard`) | Nickel contracts that compute values and validate structure. No shell access. |
| **Hunt** (`:hunt`) | Executable recipes — only permitted when the file carries a valid signature. |

# K9 ecosystem

`k9_ex` is one of several language implementations:

- [k9-rs](https://github.com/hyperpolymath/k9-rs) — Rust (reference
  implementation)

- [k9-haskell](https://github.com/hyperpolymath/k9-haskell) — Haskell

- [k9_gleam](https://github.com/hyperpolymath/k9_gleam) — Gleam (BEAM +
  JS)

- [pandoc-k9](https://github.com/hyperpolymath/pandoc-k9) — Pandoc
  reader/writer

- [tree-sitter-k9](https://github.com/hyperpolymath/tree-sitter-k9) —
  Editor grammar

# License

MPL-2.0 (required for Hex.pm). MPL-2.0 is the preferred intent; MPL-2.0
is required for the Elixir package ecosystem.

See <a href="EXPLAINME.adoc" class="adoc">EXPLAINME</a> for
implementation evidence and caveats.

# Author

Jonathan D.A. Jewell\
[j.d.a.jewell@open.ac](j.d.a.jewell@open.ac).uk
