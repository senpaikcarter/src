#!/usr/bin/env bash

set -euo pipefail

if [[ -f /etc/arch-release ]]; then
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm ansible
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf update -y
  sudo dnf install ansible -y
elif command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y ansible
else
  echo "Unsupported package manager. Install ansible manually." >&2
  exit 1
fi
