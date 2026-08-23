#!/bin/bash
set -euo pipefail

DOTFILES_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_PATH"

if command -v yay >/dev/null 2>&1; then
  yay -Qeqa >"$DOTFILES_PATH/pkglist.txt"
elif command -v pacman >/dev/null 2>&1; then
  pacman -Qeq >"$DOTFILES_PATH/pkglist.txt"
elif command -v apt >/dev/null 2>&1; then
  dpkg-query -f '${binary:Package}\n' -W >"$DOTFILES_PATH/pkglist.txt"
else
  echo "Error: no supported package manager found" >&2
  exit 1
fi

echo "pkglist.txt generated ($(wc -l <"$DOTFILES_PATH/pkglist.txt") packages)"
