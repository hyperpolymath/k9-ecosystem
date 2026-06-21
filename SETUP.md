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

`scripts/init-submodules.sh` initializes from sibling local checkouts when
they are present and skips members that are not available in the local scope.

## Validation

```sh
INPUT_PATH=. INPUT_STRICT=true INPUT_PATHS_IGNORE=$'conformance/\nmembers/' ../a2ml/a2ml-validate-action/validate-a2ml.sh
INPUT_PATH=conformance/valid INPUT_STRICT=true ../self-validating/k9-validate-action/validate-k9.sh
INPUT_PATH=conformance/invalid INPUT_STRICT=true ../self-validating/k9-validate-action/validate-k9.sh
```

The invalid K9 conformance command is expected to fail.
