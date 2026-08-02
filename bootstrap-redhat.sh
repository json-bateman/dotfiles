#!/usr/bin/env bash
set -euo pipefail

# ── config ────────────────────────────────────────────────────────────────────
USERNAME="jack"
DOTFILES_REPO="https://github.com/json-bateman/dotfiles"
HOSTNAME=""          # optional: set to override hostname, leave empty to skip
# ─────────────────────────────────────────────────────────────────────────────

if [[ $EUID -ne 0 ]]; then
  echo "Run as root or with sudo" >&2
  exit 1
fi

echo "==> Updating packages"
dnf -y update

echo "==> Installing essentials"
dnf -y install curl git openssh-server avahi

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
  passwd "$USERNAME"
  usermod -aG wheel "$USERNAME"
else
  echo "    User $USERNAME already exists, skipping"
fi

echo "==> Hardening SSH (backup at /etc/ssh/sshd_config.bak)"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/^#*AuthenticationMethods.*/AuthenticationMethods publickey/' /etc/ssh/sshd_config
systemctl restart sshd

echo ""
echo "==> System setup done. Next steps as $USERNAME:"
echo ""
echo "  1. Copy your SSH public key:"
echo "     ssh-copy-id $USERNAME@$(hostname).local"
echo ""
echo "  2. Install Nix:"
echo "     curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
echo ""
echo "  3. Clone dotfiles:"
echo "     git clone $DOTFILES_REPO ~/dotfiles"
echo ""
echo "  4. Apply home-manager:"
echo "     nix run home-manager/release-25.11 -- switch --flake ~/dotfiles/nix#redhat"
echo ""
