<!--
SPDX-License-Identifier: CC-BY-SA-4.0
Copyright (c) Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-->
# TEST-NEEDS — k9_gleam

<!-- (MPL-2.0 preferred; MPL-2.0 required for Hex.pm) -->

## CRG Grade: C — ACHIEVED 2026-04-04

## CRG C — Test Coverage Achieved

CRG C gate requires: unit, smoke, build, P2P (property-based), E2E,
reflexive, contract, aspect, and benchmark tests.

| Category      | File                                   | Count | Notes                                        |
|---------------|----------------------------------------|-------|----------------------------------------------|
| Unit          | `test/k9_gleam_test.gleam`             | 8     | Parser, renderer, security levels            |
| Smoke         | `test/k9_gleam_test.gleam`             | —     | Covered by minimal parse/render tests        |
| Build         | `gleam build`                          | —     | CI gate                                      |
| Property/P2P  | `test/k9_gleam_property_test.gleam`    | 6     | Determinism, roundtrip, invalid input loops  |
| E2E           | `test/k9_gleam_test.gleam`             | 1     | Full parse/render/re-parse roundtrip         |
| Reflexive     | `test/k9_gleam_property_test.gleam`    | 1     | Level string round-trip identity             |
| Contract      | `test/k9_gleam_contract_test.gleam`    | 9     | Named invariants (error/ok guarantees)       |
| Aspect        | `test/k9_gleam_aspect_test.gleam`      | 12    | Security, correctness, performance, resilience |
| Benchmark     | `test/k9_gleam_bench_test.gleam`       | 5     | Bulk operation correctness guards            |

**Total: 41 tests, 0 failures**

## Running Tests

```bash
gleam test
```

## Test Taxonomy (Testing Taxonomy v1.0)

- **Unit**: individual function correctness
- **Smoke**: essential path does not crash
- **Build**: compilation gate (gleam build)
- **Property/P2P**: determinism, algebraic laws, invariants over many inputs
- **E2E**: full parse → render → re-parse pipeline
- **Reflexive**: level string roundtrip identity laws
- **Contract**: named behavioural invariants (error-shape guarantee, etc.)
- **Aspect**: cross-cutting concerns (security input safety, performance bounds, resilience)
- **Benchmark**: bulk operation correctness guards (Gleam has no wall-clock assert harness)
