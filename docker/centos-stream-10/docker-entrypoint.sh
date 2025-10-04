#!/bin/sh
set -e

# Ensure host keys exist (required for sshd)
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''

# If a pubkey is provided via env, install it for 'centos'
if [ -n "${SSH_PUBKEY:-}" ]; then
  install -d -m 700 -o centos -g centos /home/centos/.ssh
  printf '%s\n' "$SSH_PUBKEY" > /home/centos/.ssh/authorized_keys
  chown centos:centos /home/centos/.ssh/authorized_keys
  chmod 600 /home/centos/.ssh/authorized_keys
else
  echo "WARNING: SSH_PUBKEY not set; key auth will not work." >&2
fi

exec "$@"
