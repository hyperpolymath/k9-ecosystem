#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

ACTION_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
FIXTURE_DIR=$(mktemp -d)
trap 'rm -rf "$FIXTURE_DIR"' EXIT

# Write valid Nickel-dialect K9 test fixtures demonstrating various pedigree
# patterns: imported schema, base contract with magic_number, and schema application.
write_valid_nickel() {
    mkdir -p "$FIXTURE_DIR/contracts"
    cat > "$FIXTURE_DIR/contracts/imported.k9.ncl" <<'EOF'
# SPDX-License-Identifier: MPL-2.0
let base = import "./base.k9.ncl" in
base.pedigree_schema & {
  name = "imported-contract",
  version = "1.0.0",
  leash = 'Yard,
}
EOF
    cat > "$FIXTURE_DIR/contracts/base.k9.ncl" <<'EOF'
# SPDX-License-Identifier: MPL-2.0
{
  magic_number = "K9!",
  pedigree = { name = "base-contract", version = "1.0.0", leash = 'Kennel },
  trust_level = "data-only",
}
EOF
    cat > "$FIXTURE_DIR/contracts/schema-application.k9.ncl" <<'EOF'
# SPDX-License-Identifier: MPL-2.0
let pedigree = import "./pedigree.ncl" in
pedigree.K9Pedigree {
  metadata = { name = "schema-application", version = "1.0.0" },
  policy = { trust_level = 'Yard },
}
EOF
}

# Write a valid plain-dialect K9 test fixture with metadata block and security_level.
write_valid_plain() {
    cat > "$FIXTURE_DIR/contracts/plain.k9" <<'EOF'
K9!
# SPDX-License-Identifier: MPL-2.0
metadata:
  name: plain-contract
  version: 1.0.0
  security_level: yard
EOF
}

# Write K9-suffixed files that should be skipped by default ignore rules:
# estate coordination files, session configs, and generated contractiles.
write_default_ignored_non_contracts() {
    mkdir -p "$FIXTURE_DIR/session" "$FIXTURE_DIR/.machine_readable/self-validating"
    cat > "$FIXTURE_DIR/coordination.k9" <<'EOF'
K9!
session_management:
  source_of_truth: standards/session-management-standards
EOF
    cat > "$FIXTURE_DIR/session/custom-checks.k9" <<'EOF'
K9!
checks:
  - id: session-state-has-next-action
EOF
    cat > "$FIXTURE_DIR/.machine_readable/self-validating/methodology-guard.k9.ncl" <<'EOF'
# SPDX-License-Identifier: MPL-2.0
{ rules = [ "guard methodology" ] }
EOF
    mkdir -p "$FIXTURE_DIR/generated/k9iser"
    cat > "$FIXTURE_DIR/generated/k9iser/container-build.k9" <<'EOF'
# Auto-generated contractiles policy. This shares a suffix but is not a K9
# pedigree contract.
[must]
security.non-root : bool { == true }
EOF
}

# Write an invalid K9 pedigree contract (has K9! marker but missing required
# pedigree fields) to test validation failure paths.
write_invalid_target() {
    cat > "$FIXTURE_DIR/contracts/invalid-target.k9" <<'EOF'
K9!
# SPDX-License-Identifier: MPL-2.0
settings:
  enabled: true
EOF
}

write_valid_nickel
write_valid_plain
write_default_ignored_non_contracts

pass_output=$(INPUT_PATH="$FIXTURE_DIR" "$ACTION_DIR/validate-k9.sh")
grep -q 'Files scanned: 4' <<< "$pass_output"
grep -q 'Files skipped: 4' <<< "$pass_output"
grep -q '3 by path, 1 without a pedigree signal' <<< "$pass_output"
grep -q 'Errors:        0' <<< "$pass_output"

# Positive control: default exclusions must not turn the validator into a
# blanket pass. An unexcluded malformed pedigree contract must still fail.
write_invalid_target
if INPUT_PATH="$FIXTURE_DIR" "$ACTION_DIR/validate-k9.sh" > "$FIXTURE_DIR/invalid.log" 2>&1; then
    echo 'expected invalid-target.k9 to fail validation' >&2
    exit 1
fi
grep -q 'Missing pedigree' "$FIXTURE_DIR/invalid.log"

# An explicitly empty override disables all defaults, so the non-contract
# coordination files become visible and make the lexical pedigree gate fail.
if INPUT_PATH="$FIXTURE_DIR" INPUT_PATHS_IGNORE='' \
    "$ACTION_DIR/validate-k9.sh" > "$FIXTURE_DIR/no-ignore.log" 2>&1; then
    echo 'expected empty paths-ignore override to scan and reject non-contract files' >&2
    exit 1
fi
grep -q 'coordination.k9' "$FIXTURE_DIR/no-ignore.log"

echo 'K9 validator regression tests passed'
