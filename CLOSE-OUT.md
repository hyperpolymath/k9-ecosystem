<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
# K9 Ecosystem — Close-Out

Decision ledger for the coordination-hub rebuild.

## Decided

- **Shape.** The hub is a coordination hub plus pinned submodules — a sibling of
  `developer-ecosystem` and a satellite of `hyperpolymath/standards`.
- **Drift model.** Pin + verify: upstream spec and governance are referenced by
  pinned tag and checked in CI, never hard-linked or copied.
- **Members.** 12 members across implementations / tooling / ci / examples,
  pinned as submodule gitlinks on `main`. `k9-svc` is not a member; it is
  recorded only as a future related reference.
- **Governance layout.** Machine-readable metadata lives under
  `.machine_readable/` only; `0-AI-MANIFEST.a2ml` is the root entry point.
- **Conformance verified.** 3 valid (Kennel / Yard / Hunt) + 4 invalid
  `.k9.ncl` fixtures, indexed by `conformance/manifest.a2ml`: valid validates
  with 0 errors; invalid (strict) errors on every case.

## Issues (filed)

- Pin canonical spec in standards + replace TODO-tag — `decision, governance`
- Member rollout: ANCHOR satellite+pin+conformance CI; enable upstream-pins — `rollout`
- Canonical parse-AST (expected.json) + expand conformance corpus — `conformance`
- Governance parity: stamp standard `.machine_readable` + CONTRIBUTING/SECURITY/COC from standards — `governance`
- Author tiered dev/maintainer/user docs + concept guides — `docs`
- Reference this hub from developer-ecosystem / standards — `meta`
- Resolve spec home: standards/CONTRACTILE-SPEC vs create k9-svc — `decision`

## Open Decision

- **Spec home.** Either pin `docs/CONTRACTILE-SPEC.adoc` in
  `hyperpolymath/standards`, or create a dedicated `k9-svc` repository to own
  the contractile specification. Until resolved, the pin stays `TODO-tag` and
  `k9-svc` remains a future related reference only.

## Discarded

- Bundling member sources into the hub (rejected: members stay independent).
- WSL-specific tooling assumptions (rejected: not portable).
- base64-embedded payloads for fixtures or metadata (rejected: opaque and
  unverifiable).

## Cleanup

- After the PR merges, delete the development branch
  `claude/gracious-goodall-4vnq77`.
