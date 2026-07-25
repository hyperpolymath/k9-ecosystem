<!--
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025-2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-->

# Overview

**GitHub Action to validate K9 configuration files in your repository.**

K9 is a Nickel-based configuration contract format used by the
contractile system for deployment validation and policy enforcement.
Files use the `.k9` or `.k9.ncl` extension and follow a security-tiered
"leash" model: kennel (data-only), yard (validated), and hunt (full
execution).

# Checks Performed

1.  **K9! magic number** — First non-empty line must be exactly `K9!`

2.  **SPDX header** — Verifies `SPDX-License-Identifier` in the first 10
    lines

3.  **Pedigree block** — Requires a `pedigree` `=` `{` `…` `}` section
    with:

    - `name` field (in `pedigree.metadata` or directly)

    - `version` or `schema_version` field

4.  **Security level** — `leash` or `security_level` must be one of:
    `kennel`, `yard`, `hunt`

5.  **Hunt-level signature** — Files at `hunt` security level must
    include a `signature` or `signature_required` field

# Usage

Add to your workflow:

```yaml
name: Validate K9
on: [push, pull_request]

permissions:
  contents: read

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hyperpolymath/k9-validate-action@v1
        with:
          path: '.'        # Directory to scan (default: repo root)
          strict: 'false'  # Promote warnings to errors (default: false)
          # paths-ignore: defaults to vendored / fixture patterns; override
          # via newline-separated string. Use '' to disable.
```

## Inputs

| Input | Default | Description |
|----|----|----|
| `path` | `.` | Directory path to scan for K9 files |
| `strict` | `false` | When `true`, warnings become errors and the action fails on any issue |
| `paths-ignore` | *vendored & fixture defaults* | Newline-separated path fragments to skip. Substring match against each file path. Default set: `vendor/`, `vendored/`, `verified-container-spec/`, `.audittraining/`, `integration/fixtures/`, `test/fixtures/`, `tests/fixtures/`. Pass an empty string (`paths-ignore:` `’’`) to disable and scan everything. See <https://github.com/hyperpolymath/hypatia/pull/243> for the architectural rationale (content-pattern validators must distinguish targets from fixtures / vendored / training-corpus files that legitimately contain the very pattern being checked). |

### Why default-on path exemptions?

K9 files inside vendored projects (e.g. `verified-container-spec/`)
carry their own pedigree declarations in their upstream context —
flagging every such file as "Pedigree block missing ’name’ field" is
provenance noise. The defaults match the canonical RSR vendored-content
paths; override for project-specific carve-outs.

## Outputs

| Output          | Description                  |
|-----------------|------------------------------|
| `files-scanned` | Number of K9 files processed |
| `errors`        | Count of validation errors   |
| `warnings`      | Count of validation warnings |

# Security Levels

| Level | Trust | Requirements |
|----|----|----|
| `kennel` | Data-only | No signature required. Pure configuration values. |
| `yard` | Validated | Nickel contracts enforced. Type-checked before use. |
| `hunt` | Full access | **Signature required.** Can execute commands and access system resources. |

# Author

Jonathan D.A. Jewell \<[j.d.a.jewell@open.ac](j.d.a.jewell@open.ac).uk\>

# License

SPDX-License-Identifier: CC-BY-SA-4.0

See [LICENSE](LICENSE) for details.
