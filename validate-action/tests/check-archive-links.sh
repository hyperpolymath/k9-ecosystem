#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
# Actions downloads the entire repository archive, including files outside
# validate-action. Dangling or external links can prevent extraction entirely.
set -euo pipefail
root=$(realpath -e "${1:-.}")
failed=0
while IFS= read -r -d '' link; do
  if ! target=$(realpath -e "$link"); then
    echo "::error::Dangling archive link: ${link#"$root/"}" >&2
    failed=1
  elif [[ "$target" != "$root" && "$target" != "$root/"* ]]; then
    echo "::error::Archive link escapes the repository: ${link#"$root/"}" >&2
    failed=1
  fi
done < <(find "$root" -name .git -prune -o -type l -print0)
exit "$failed"
