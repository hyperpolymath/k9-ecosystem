#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

failures=0

fail() {
  printf 'membership error: %s\n' "$1" >&2
  failures=$((failures + 1))
}

check_member() {
  local group="$1"
  local name="$2"
  local url="https://github.com/hyperpolymath/${name}.git"
  local path="members/${group}/${name}"
  local module="submodule.${path}"
  local actual_url
  local actual_branch
  local mode

  if ! grep -Fq "(member \"${name}\" (group \"${group}\")" ECOSYSTEM.a2ml; then
    fail "ECOSYSTEM.a2ml missing ${group}/${name}"
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

check_member implementations k9-rs
check_member implementations k9_ex
check_member implementations k9_gleam
check_member implementations k9-deno
check_member implementations k9-haskell
check_member tooling tree-sitter-k9
check_member tooling vscode-k9
check_member tooling pandoc-k9
check_member tooling k9iser
check_member ci k9-validate-action
check_member ci k9-pre-commit
check_member examples k9-showcase

if ! grep -Fq '(related "k9-svc"' ECOSYSTEM.a2ml; then
  fail "ECOSYSTEM.a2ml missing future k9-svc related reference"
fi

if [[ "${failures}" -gt 0 ]]; then
  exit 1
fi

printf 'membership integrity passed\n'
