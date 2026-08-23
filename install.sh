#!/bin/bash
set -euo pipefail

DOTFILES_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_PATH"

while IFS= read -r src || [ -n "$src" ]; do
  src="${src%"${src##*[![:space:]]}"}"

  dst="$HOME/$src"
  src_full="$DOTFILES_PATH/$src"

  if [ ! -e "$src_full" ]; then
    echo "WARN: skipping $src (not found)" >&2
    continue
  fi

  mkdir -p "$(dirname "$dst")"
  if [ -d "$src_full" ]; then
    cp -a "$src_full"/. "$dst"/
  else
    cp -a "$src_full" "$dst"
  fi
  echo "copied: $src -> $dst"
done <dotfiles.txt

echo "Done."
