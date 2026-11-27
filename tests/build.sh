#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
# Build (BLD): the build inputs exist and parse (no toolchain needed).
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 2
. tests/kit/lib/ptb.sh
for f in Justfile Containerfile compose.yaml mise.toml manifest.scm deno/jsr.json; do
  [[ -s $f ]] || { echo "build: $f missing or empty; absence is not a pass" >&2; exit 2; }
  ptb_ok "BLD-present-$f" test -s "$f"
done
ptb_ok BLD-jsr-json-valid jq -e . deno/jsr.json
ptb_fails BLD-negative-control-json jq -e . <(echo '{')
ptb_done
