<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk> -->
# TOPOLOGY.md — k9-showcase

## Purpose

Content showcase for K9 (Self-Validating Components): example `.k9` files, getting-started guides, integration examples, and security-level demonstrations. No executable code — pure content and documentation repo for the K9 format.

## Module Map

```
k9-showcase/
├── content/
│   ├── examples.md         # K9 usage examples
│   ├── getting-started.md  # Quickstart guide
│   ├── integrations.md     # Integration guides
│   ├── security-levels.md  # Kennel/Yard/Hunt tier docs
│   └── specification.md    # K9 format specification
├── output/                 # Rendered output
└── deno.json               # Deno task runner config
```

## Data Flow

```
[content/*.md + .k9 examples] ──► [Deno renderer] ──► [output/]
```
