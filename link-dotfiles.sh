#!/bin/bash
set -euo pipefail

DOTFILES_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LINKS_FILE="$DOTFILES_PATH/dotfiles.txt"
cd "$DOTFILES_PATH"

if [ ! -f "$LINKS_FILE" ]; then
  echo "Error: $LINKS_FILE not found" >&2
  exit 1
fi

while IFS= read -r src || [ -n "$src" ]; do
  src="${src%"${src##*[![:space:]]}"}"
  dst="$HOME/$src"

  src_full="$DOTFILES_PATH/$src"

  if [ ! -e "$src_full" ] && [ ! -L "$src_full" ]; then
    echo "WARN: source not found, skipping: $src" >&2
    continue
  fi

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mkdir -p "$(dirname "$src_full")"
    if [ -d "$dst" ]; then
      mkdir -p "$src_full"
      cp -a "$dst"/. "$src_full"/
    else
      cp -a "$dst" "$src_full"
    fi
    mv "$dst" "$dst.bak"
    echo "backed up: $dst -> $dst.bak"
  fi

  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    if [ "$(readlink "$dst")" != "$src_full" ]; then
      ln -sfn "$src_full" "$dst"
      echo "relinked: $dst -> $src_full"
    fi
  else
    ln -sfn "$src_full" "$dst"
    echo "linked: $dst -> $src_full"
  fi
done

echo "Done."
