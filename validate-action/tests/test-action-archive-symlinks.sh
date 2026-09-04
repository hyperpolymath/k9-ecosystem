#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
# GitHub downloads the whole repository before entering a subdirectory action.
# A tracked symlink that escapes the repository, or whose target is absent,
# makes that download fail before the composite action can start.
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)

check_target() {
  local root="$1" link_path="$2" target="$3" root_real resolved
  root_real=$(realpath -m "$root")
  resolved=$(realpath -m "$(dirname "$link_path")/$target")

  case "$resolved" in
    "$root_real"|"$root_real"/*) ;;
    *) return 10 ;;
  esac
  [[ -e "$resolved" ]] || return 11
}

# Positive controls: demonstrate that the checker accepts an internal target
# and rejects both an escaping and a dangling target.
control_dir=$(mktemp -d -t k9-action-symlinks.XXXXXX)
trap 'rm -rf "$control_dir"' EXIT
mkdir -p "$control_dir/repo/sub"
touch "$control_dir/repo/target"
check_target "$control_dir/repo" "$control_dir/repo/sub/link" ../target

set +e
check_target "$control_dir/repo" "$control_dir/repo/sub/link" ../../outside
escape_status=$?
check_target "$control_dir/repo" "$control_dir/repo/sub/link" ../missing
dangling_status=$?
set -e
[[ "$escape_status" -eq 10 && "$dangling_status" -eq 11 ]] || {
  echo 'positive control failed: unsafe symlinks were not classified correctly' >&2
  exit 1
}

failures=0
while IFS=$'\t' read -r metadata path; do
  mode=${metadata%% *}
  [[ "$mode" == 120000 ]] || continue
  target=$(git show ":$path")
  set +e
  check_target "$repo_root" "$repo_root/$path" "$target"
  status=$?
  set -e
  if [[ "$status" -ne 0 ]]; then
    if [[ "$status" -eq 10 ]]; then
      echo "archive-escaping symlink: $path -> $target" >&2
    else
      echo "dangling symlink: $path -> $target" >&2
    fi
    failures=$((failures + 1))
  fi
done < <(git ls-files -s)

[[ "$failures" -eq 0 ]] || {
  echo "$failures unsafe tracked symlink(s) would break GitHub action download" >&2
  exit 1
}
echo 'action archive symlink check passed'
