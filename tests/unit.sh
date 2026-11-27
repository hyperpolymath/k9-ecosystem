#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
# Unit (UT): toolchain-free checks of the repo's shell scripts and conformance fixtures.
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 2
. tests/kit/lib/ptb.sh
mapfile -d '' scripts < <(git ls-files -z -- '*.sh')
[[ ${#scripts[@]} -gt 0 ]] || { echo "unit: no shell scripts found" >&2; exit 2; }
for s in "${scripts[@]}"; do
  case $(head -1 "$s") in *bash*) sh=bash ;; *) sh=sh ;; esac
  ptb_ok "UT-syntax-$s" "$sh" -n "$s"
done
ptb_fails UT-negative-control-syntax bash -n <(echo 'if then fi')
mapfile -d '' valid < <(git ls-files -z -- 'conformance/valid/*.k9.ncl')
[[ ${#valid[@]} -gt 0 ]] || { echo "unit: no valid fixtures" >&2; exit 2; }
for f in "${valid[@]}"; do ptb_eq "UT-magic-$f" "K9!" "$(head -1 "$f")"; done
ptb_fails UT-negative-control-magic test "$(head -1 conformance/invalid/no-magic-line.k9.ncl)" = "K9!"
ptb_done
