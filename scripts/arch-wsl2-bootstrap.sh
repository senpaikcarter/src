#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="${REPO_ROOT:-$HOME/src}"
PLAYBOOK="${PLAYBOOK:-$REPO_ROOT/playbooks/arch-wsl2.yml}"

if [[ ! -f "$PLAYBOOK" ]]; then
  echo "Playbook not found: $PLAYBOOK" >&2
  exit 1
fi

if [[ -r /proc/version ]] && ! grep -qi microsoft /proc/version; then
  echo "Warning: this bootstrap was written for WSL2 and you're not on a detected WSL kernel." >&2
fi

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm ansible git curl

ansible-playbook --connection=local --inventory localhost, --ask-become-pass "$PLAYBOOK"
