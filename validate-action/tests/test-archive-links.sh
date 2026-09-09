#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
set -euo pipefail
checker="$(cd "$(dirname "$0")" && pwd)/check-archive-links.sh"
fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT
mkdir -p "$fixture/repo/assets"
printf 'fixture\n' > "$fixture/repo/assets/style.css"
ln -s assets/style.css "$fixture/repo/style.css"
bash "$checker" "$fixture/repo"
ln -s ../missing "$fixture/repo/broken"
if bash "$checker" "$fixture/repo"; then
  echo 'FAIL: dangling link accepted' >&2
  exit 1
fi
rm "$fixture/repo/broken"
printf 'outside\n' > "$fixture/outside"
ln -s ../outside "$fixture/repo/escape"
if bash "$checker" "$fixture/repo"; then
  echo 'FAIL: external link accepted' >&2
  exit 1
fi
echo 'PASS: internal links pass; dangling and external archive links fail'
