#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
# P2P: seam between conformance/manifest.a2ml and the fixture files it names.
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 2
. tests/kit/lib/ptb.sh
mapfile -t refs < <(grep -o 'fixture "[^"]*"' conformance/manifest.a2ml | cut -d'"' -f2)
[[ ${#refs[@]} -gt 0 ]] || { echo "p2p: manifest names no fixtures" >&2; exit 2; }
for r in "${refs[@]}"; do ptb_ok "P2P-fixture-$r" test -s "conformance/$r"; done
ptb_fails P2P-negative-control-missing test -s conformance/valid/does-not-exist.k9.ncl
n=$(git ls-files -- 'conformance/valid/*.k9.ncl' 'conformance/invalid/*.k9.ncl' | wc -l)
ptb_eq P2P-every-fixture-listed "${#refs[@]}" "$n"
ptb_done
