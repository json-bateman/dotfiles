#!/usr/bin/env bash
set -euo pipefail

USERNAME="jack"
DOTFILES_REPO="https://github.com/json-bateman/dotfiles"
HOSTNAME=""          # optional: set to override hostname, leave empty to skip

if [[ $EUID -ne 0 ]]; then
  echo "Run as root or with sudo" >&2
  exit 1
fi

# Directory this script lives in, so we can find repo files (authorized_keys, etc.)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Updating packages"
dnf -y update

echo "==> Installing essentials"
dnf -y install curl openssh-server avahi

echo "==> Enabling SSH + mDNS"
systemctl enable --now sshd
systemctl enable --now avahi-daemon

echo "==> Configuring firewall"
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=mdns
firewall-cmd --reload

if [[ -n "$HOSTNAME" ]]; then
  echo "==> Setting hostname to $HOSTNAME"
  hostnamectl set-hostname "$HOSTNAME"
fi

echo "==> Creating user $USERNAME"
if ! id "$USERNAME" &>/dev/null; then
  useradd -m -s /bin/bash "$USERNAME"
  usermod -aG wheel "$USERNAME"
else
  echo "    User $USERNAME already exists, skipping"
fi

echo "==> Enabling passwordless sudo for $USERNAME"
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/"$USERNAME"
chmod 440 /etc/sudoers.d/"$USERNAME"
visudo -cf /etc/sudoers.d/"$USERNAME"

echo "==> Installing authorized_keys for $USERNAME"
install -d -m 700 -o "$USERNAME" -g "$USERNAME" /home/"$USERNAME"/.ssh
install -m 600 -o "$USERNAME" -g "$USERNAME" \
  "$SCRIPT_DIR/authorized_keys" /home/"$USERNAME"/.ssh/authorized_keys

echo "==> Hardening SSH (backup at /etc/ssh/sshd_config.bak)"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/^#*AuthenticationMethods.*/AuthenticationMethods publickey/' /etc/ssh/sshd_config
systemctl restart sshd

echo "==> Installing Nix (Determinate Systems)"
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
  | sh -s -- install --no-confirm

echo ""
echo "==> System setup done. Next steps as $USERNAME:"
echo ""
echo "  1. Apply home-manager (new shell so nix is on PATH):"
echo "     nix run home-manager/release-25.11 -- switch --flake ~/dotfiles/nix#redhat"
echo ""
