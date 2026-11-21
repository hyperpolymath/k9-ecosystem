#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

failures=0
manifest=.machine_readable/descriptiles/ECOSYSTEM.a2ml

# Report a membership validation error and increment the failure counter.
fail() {
  printf 'membership error: %s\n' "$1" >&2
  failures=$((failures + 1))
}

# In-tree members must point to a tracked component, not a submodule.
check_in_tree() {
  local group="$1" name="$2" path="$3"

  if ! grep -Fq "(member \"${name}\" (group \"${group}\") (path \"${path}\"))" "$manifest"; then
    fail "${manifest} missing in-tree entry ${group}/${name} at ${path}"
  fi

  if [[ ! -d "$path" ]] || ! git ls-files --error-unmatch -- "${path}/README.adoc" >/dev/null 2>&1; then
    fail "${path} is not a tracked in-tree component"
  fi
}

# Independent members must match the manifest, .gitmodules, and index.
check_submodule() {
  local group="$1"
  local name="$2"
  local url="https://github.com/hyperpolymath/${name}.git"
  local path="members/${group}/${name}"
  local module="submodule.${path}"
  local actual_url
  local actual_branch
  local mode

  if ! grep -Fq "(member \"${name}\" (group \"${group}\") (path \"${path}\") (branch \"main\") (repo \"hyperpolymath/${name}\"))" "$manifest"; then
    fail "${manifest} missing submodule entry ${group}/${name}"
  fi

  if [[ "$(git config -f .gitmodules --get "${module}.path" || true)" != "${path}" ]]; then
    fail ".gitmodules missing path ${path}"
  fi

  actual_url="$(git config -f .gitmodules --get "${module}.url" || true)"
  if [[ "${actual_url}" != "${url}" ]]; then
    fail ".gitmodules ${path} url is '${actual_url}', expected '${url}'"
  fi

  actual_branch="$(git config -f .gitmodules --get "${module}.branch" || true)"
  if [[ "${actual_branch}" != "main" ]]; then
    fail ".gitmodules ${path} branch is '${actual_branch}', expected 'main'"
  fi

  mode="$(git ls-files -s "${path}" | awk '{print $1}')"
  if [[ "${mode}" != "160000" ]]; then
    fail "${path} is not a pinned submodule gitlink"
  fi
}

check_in_tree implementations k9-rs rs
check_in_tree implementations k9_ex ex
check_in_tree implementations k9_gleam gleam
check_in_tree implementations k9-deno deno
check_in_tree implementations k9-haskell haskell
check_in_tree tooling vscode-k9 editors/vscode
check_in_tree tooling pandoc-k9 pandoc
check_in_tree ci k9-validate-action validate-action
check_in_tree examples k9-showcase showcase
check_submodule ci k9-pre-commit

if ! grep -Fq '(related "k9-svc"' "$manifest"; then
  fail "${manifest} missing future k9-svc related reference"
fi

if [[ "${failures}" -gt 0 ]]; then
  exit 1
fi

printf 'membership integrity passed\n'
