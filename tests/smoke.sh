#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
# Smoke (SMK): the top-level test driver parses and the kit smoke helper runs it.
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 2
. tests/kit/lib/ptb.sh
[[ -f test.sh ]] || { echo "smoke: test.sh missing; absence is not a pass" >&2; exit 2; }
ptb_ok SMK-driver-syntax sh -n test.sh
ptb_ok SMK-kit-smoke tests/kit/lib/smoke.sh --expect 'K9!' -- head -1 conformance/valid/ci-config.k9.ncl
ptb_fails SMK-missing-binary-is-not-a-pass tests/kit/lib/smoke.sh --expect x -- /nonexistent/binary
ptb_done
