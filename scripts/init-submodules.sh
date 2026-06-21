#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
workspace_root="$(cd "${repo_root}/.." && pwd)"

init_member() {
  local group="$1"
  local name="$2"
  local local_rel="$3"
  local dest="${repo_root}/members/${group}/${name}"
  local source="${workspace_root}/${local_rel}"
  local gitlink

  gitlink="$(git -C "${repo_root}" rev-parse ":members/${group}/${name}" 2>/dev/null || true)"
  if [[ -z "${gitlink}" ]]; then
    printf 'skip %s/%s: no gitlink recorded\n' "${group}" "${name}"
    return 0
  fi

  if [[ -e "${dest}/.git" || -f "${dest}/.git" ]]; then
    printf 'present %s/%s\n' "${group}" "${name}"
    return 0
  fi

  if [[ ! -d "${source}/.git" ]]; then
    printf 'skip %s/%s: local repo not in scope at %s\n' "${group}" "${name}" "${source}"
    return 0
  fi

  mkdir -p "$(dirname "${dest}")"
  git -c protocol.file.allow=always clone "${source}" "${dest}"
  git -C "${dest}" checkout --detach "${gitlink}"
  git -C "${repo_root}" submodule absorbgitdirs "members/${group}/${name}" >/dev/null 2>&1 || true
  printf 'initialized %s/%s at %s\n' "${group}" "${name}" "${gitlink}"
}

init_member implementations k9-rs "self-validating/k9-core/k9-rs"
init_member implementations k9_ex "self-validating/k9_ex"
init_member implementations k9_gleam "self-validating/k9_gleam"
init_member implementations k9-deno "self-validating/k9-core/k9-deno"
init_member implementations k9-haskell "self-validating/k9-core/k9-haskell"
init_member tooling tree-sitter-k9 "self-validating/tree-sitter-k9"
init_member tooling vscode-k9 "self-validating/vscode-k9"
init_member tooling pandoc-k9 "self-validating/pandoc-k9"
init_member tooling k9iser "isers/k9iser"
init_member ci k9-validate-action "self-validating/k9-validate-action"
init_member ci k9-pre-commit "self-validating/k9-core/k9-pre-commit"
init_member examples k9-showcase "self-validating/k9-core/k9-showcase"
