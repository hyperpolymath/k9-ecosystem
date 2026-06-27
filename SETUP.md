# Setup

This repository is a coordination hub and satellite of
`hyperpolymath/standards`.

## Fresh Checkout

```sh
git clone https://github.com/hyperpolymath/k9-ecosystem.git
cd k9-ecosystem
git submodule update --init --recursive
```

For local estate work, prefer:

```sh
scripts/init-submodules.sh
scripts/check-membership.sh
```

`scripts/init-submodules.sh` initializes from sibling local checkouts when they
are present and skips members that are not available in the local scope.
`scripts/check-membership.sh` reads `.machine_readable/6a2/ECOSYSTEM.a2ml`.

## Machine-Readable Layout

Coordination metadata lives under `.machine_readable/` only:

- `.machine_readable/anchors/ANCHOR.a2ml` — authority anchor and upstream pins.
- `.machine_readable/6a2/ECOSYSTEM.a2ml` — membership manifest.
- `.machine_readable/6a2/{STATE,META,PLAYBOOK,AGENTIC,NEUROSYM}.a2ml` — hub
  state, ADRs, playbook, and agentic / neuro-symbolic notes.

`0-AI-MANIFEST.a2ml` at the repository root indexes this surface.

## Validation

```sh
# governance: the .a2ml coordination surface, strict, ignoring fixtures and members
INPUT_PATH=. INPUT_STRICT=true INPUT_PATHS_IGNORE=$'conformance/\nmembers/' ../a2ml/a2ml-validate-action/validate-a2ml.sh
# K9 conformance positive (zero errors) and negative (every case errors)
INPUT_PATH=conformance/valid INPUT_STRICT=true ../self-validating/k9-validate-action/validate-k9.sh
INPUT_PATH=conformance/invalid INPUT_STRICT=true ../self-validating/k9-validate-action/validate-k9.sh
```

The invalid K9 conformance command is expected to fail.
