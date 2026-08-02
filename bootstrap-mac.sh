#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="https://github.com/json-bateman/dotfiles"

echo "==> Homebrew"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "==> Nix"
if ! command -v nix &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

echo "==> Dotfiles"
if [[ ! -d "$HOME/dotfiles" ]]; then
  git clone "$DOTFILES_REPO" ~/dotfiles
fi

echo "==> Home Manager"
if ! command -v home-manager &>/dev/null; then
  nix run home-manager/release-25.11 -- switch --flake ~/dotfiles/nix#mac
else
  home-manager switch --flake ~/dotfiles/nix#mac
fi

echo "==> GUI apps (Cask)"
brew install --cask \
  wezterm \
  spotify \
  google-chrome \
  telegram \
  docker

echo ""
echo "==> Done. Open a new shell to pick up your environment."
