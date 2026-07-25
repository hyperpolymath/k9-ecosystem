<!--
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025-2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-->

**Content-only showcase of K9 document examples, templates, and rendered
output.**

![License:
MPL-2.0](https://img.shields.io/badge/License-MPL--2.0-blue.svg)
![K9](https://img.shields.io/badge/format-K9-green.svg) ![Content
only](https://img.shields.io/badge/type-content--only-lightgrey.svg)

# What this is

`k9-showcase` is a documentation and examples repository for the K9
configuration format. It contains no executable code — only:

- Human-readable explanations of K9’s three-level security model

- Worked example K9 files at each level

- Integration guides for K9 tooling

- Rendered HTML output from the content pages

K9 is the hyperpolymath configuration and policy format with three
graduated security levels:

| Level | File type | What it permits |
|----|----|----|
| **Kennel** | `.k9` | Pure data. No evaluation, no execution. Equivalent to `Cargo.toml`. |
| **Yard** | `.k9.ncl` (unevaluated) | Nickel contracts for typed validation. No shell access. |
| **Hunt** | `.k9.ncl` (cryptographically signed) | Executable recipes. Requires a valid signature — deliberate trust gate. |

# Quick start

```bash
# Run the test suite (verifies content structure)
deno test --allow-read tests/

# Or via justfile
just default
```

There is no application to run — browse `content/` or `output/`
directly.

# Content layout

| File | What it explains |
|----|----|
| `content/index.md` | The three-level model, "What is K9?", level badges overview |
| `content/getting-started.md` | Step-by-step: write a first `.k9` file, add Nickel contracts, sign for Hunt |
| `content/examples.md` | Annotated K9 files at each level. Includes a complete Kennel-level `project.k9` for `panic-attacker`. |
| `content/integrations.md` | Tooling: tree-sitter-k9, IANA media type, freedesktop.org MIME, VS Code |
| `content/security-levels.md` | Deep dive on the trust model and signing gate |
| `output/` | Rendered HTML (from `content/` via `template.html`) |
| `template.html` | HTML template used to produce `output/` pages |

# K9 tooling ecosystem

| Repo | Purpose |
|----|----|
| [tree-sitter-k9](https://github.com/hyperpolymath/tree-sitter-k9) | Generated C parser; editor integration (Neovim, Helix, Zed) |
| [k9-rs](https://github.com/hyperpolymath/k9-rs) | Rust reference implementation |
| [k9_ex](https://github.com/hyperpolymath/k9_ex) | Elixir implementation |
| [k9_gleam](https://github.com/hyperpolymath/k9_gleam) | Gleam implementation (BEAM + JS) |
| [format-registrations](https://github.com/hyperpolymath/format-registrations) | IANA `application/vnd.k9` registration + freedesktop.org MIME XML |
| [standards](https://github.com/hyperpolymath/standards) | K9 language specification |

See <a href="EXPLAINME.adoc" class="adoc">EXPLAINME</a> for an honest
map from each claim to its implementation evidence and caveats.

# License

MPL-2.0. See `LICENSE`.

# Author

Jonathan D.A. Jewell\
[j.d.a.jewell@open.ac](j.d.a.jewell@open.ac).uk
