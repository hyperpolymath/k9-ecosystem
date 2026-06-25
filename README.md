<!--
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025-2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-->

`hyperpolymath/k9-ecosystem` coordinates implementations, tooling, CI
integrations, examples, and conformance fixtures for K9 self-validating
components and Nickel contractiles.

This repository is a satellite of `hyperpolymath/standards`. It does not
own the K9 contractile specification or governance rules. The upstream
specification and governance authority are pinned in
<a href="ANCHOR.a2ml" class="a2ml">ANCHOR</a> by tag.

# Owned Here

- <a href="ECOSYSTEM.a2ml" class="a2ml">ECOSYSTEM</a> records the member
  repository manifest.

- [conformance/manifest.a2ml](conformance/manifest.a2ml) indexes the
  local positive and negative K9 fixtures.

- [scripts/check-membership.sh](scripts/check-membership.sh) checks that
  manifest entries, submodule declarations, and gitlinks stay aligned.

- `.github/workflows/anchor-drift.yml` runs anchor drift checks in CI.

# Not Owned Here

The K9 contractile specification is owned by `hyperpolymath/standards`.
This hub points to `docs/CONTRACTILE-SPEC.adoc` there; until the first
standards tag is cut, the pin is intentionally `TODO-tag`.

The referenced `k9-svc` repository does not exist yet and is not listed
as a member submodule.

# Membership Layout

Member repositories are pinned as submodules under
`members/<group>/<name>` on their `main` branches. The groups are:

- `implementations`

- `tooling`

- `ci`

- `examples`
