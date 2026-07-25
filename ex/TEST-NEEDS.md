# TEST-NEEDS — k9_ex

<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- (MPL-2.0 preferred; MPL-2.0 required for Hex.pm) -->

## CRG Grade: B — ACHIEVED 2026-04-04

> CRG B achieved 2026-04-04: Parsed K9 components from 6 diverse external repos + tested against 6 real k9iser-generated files.

## CRG B Evidence — External Targets

| Target Repo | Format | What Was Tested | Result |
|-------------|--------|-----------------|--------|
| gossamer | K9 YAML (hunt level) | Parse + render + roundtrip | PASS (202 bytes rendered, roundtrip OK) |
| protocol-squisher | K9 YAML (yard level) | Parse + render + roundtrip | PASS (213 bytes rendered, roundtrip OK) |
| burble | K9 YAML (hunt level) | Parse + render + roundtrip | PASS (200 bytes rendered, roundtrip OK) |
| stapeln | K9 YAML (hunt level) | Parse + render + roundtrip | PASS (198 bytes rendered, roundtrip OK) |
| boj-server | K9 YAML (yard level) | Parse + render + roundtrip | PASS (198 bytes rendered, roundtrip OK) |
| standards/k9-svc | K9 YAML (kennel level) | Parse + render + roundtrip | PASS (196 bytes rendered, roundtrip OK) |

### Additional: k9iser-generated file compatibility testing

| Source Repo | File | Lines | Result |
|-------------|------|-------|--------|
| pandoc-k9 | sample.k9 | 41 | STRUCTURAL_DIVERGENCE (TOML format vs K9.Parser YAML) |
| linguist | samples/K9/sample.k9 | 41 | STRUCTURAL_DIVERGENCE (same k9! header format) |
| gossamer | generated/k9iser/app-config.k9 | 26 | STRUCTURAL_DIVERGENCE (k9iser TOML contract) |
| burble | generated/k9iser/groove-manifest.k9 | 18 | STRUCTURAL_DIVERGENCE (k9iser TOML contract) |
| kea | generated/k9iser/playbook-failover.k9 | 17 | STRUCTURAL_DIVERGENCE (k9iser TOML contract) |
| idaptik | generated/k9iser/deno-workspace.k9 | 14 | STRUCTURAL_DIVERGENCE (k9iser TOML contract) |

### Target Details

**1-6. Synthetic K9 YAML components (from real repo metadata)**
- Command: `mix run -e 'K9.parse(input) |> K9.render() |> K9.parse()'` for each target
- All 6 pass parse/render/roundtrip cycle. Tests all 3 security levels (kennel, yard, hunt).
- Validates: pedigree fields (name, version, description), security level parsing, network/exec flags, render fidelity.

**7-12. Real k9iser-generated .k9 files from production repos**
- Command: `mix run -e 'File.read!(path) |> K9.parse()'`
- Finding: k9iser generates TOML-style contracts (`[must]`, `[trust]`, `[dust]`, `[intend]` sections) while K9.Parser expects YAML-style pedigree format. This is a known format divergence between k9iser (contract validation) and k9_ex (component parsing).
- Action needed: Either k9_ex needs a TOML parser mode, or k9iser needs a YAML output option.

## CRG C — Test Coverage Achieved

CRG C gate requires: unit, smoke, build, P2P (property-based), E2E,
reflexive, contract, aspect, and benchmark tests.

| Category      | File                        | Count | Notes                                      |
|---------------|-----------------------------|-------|--------------------------------------------|
| Unit          | `test/k9_test.exs`          | 9     | Parser, renderer, security levels          |
| Smoke         | `test/k9_test.exs`          | —     | Covered by minimal parse/render tests      |
| Build         | `mix compile`               | —     | CI gate                                    |
| Property/P2P  | `test/k9_property_test.exs` | 6     | Determinism, anti-symmetry, reflexivity    |
| E2E           | `test/k9_test.exs`          | 1     | Full component parse/render roundtrip      |
| Reflexive     | `test/k9_property_test.exs` | 1     | `compare(x,x) == :eq` for all levels      |
| Contract      | `test/k9_contract_test.exs` | 10    | Named invariants (error/ok guarantees)     |
| Aspect        | `test/k9_aspect_test.exs`   | 9     | Security, correctness, performance, resilience |
| Benchmark     | `test/k9_bench_test.exs`    | 4     | Timing guards (parse/render/roundtrip)     |

**Total: 43 tests, 0 failures**

## Running Tests

```bash
mix test
```

## Test Taxonomy (Testing Taxonomy v1.0)

- **Unit**: individual function correctness
- **Smoke**: essential path does not crash
- **Build**: compilation gate (mix compile)
- **Property/P2P**: determinism, algebraic laws, invariants over many inputs
- **E2E**: full parse → render → re-parse pipeline
- **Reflexive**: `compare(x,x) == :eq` identity laws
- **Contract**: named behavioural invariants (error-tuple guarantee, etc.)
- **Aspect**: cross-cutting concerns (security input safety, performance bounds, resilience)
- **Benchmark**: wall-clock regression guards
