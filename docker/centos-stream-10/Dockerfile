# CentOS Stream 10
FROM quay.io/centos/centos:stream10

# sshd, sudo, python for Ansible
RUN dnf -y update && \
    dnf -y install openssh-server sudo which python3 && \
    dnf clean all

# Create login user
RUN useradd -m -s /bin/bash centos && \
    echo 'centos ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/centos && \
    chmod 440 /etc/sudoers.d/centos

# Lock down sshd (key-only, no root login)
RUN sed -ri 's/^#?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PubkeyAuthentication .*/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -ri 's@^#?Port .*@Port 22@' /etc/ssh/sshd_config

# Entry script writes $SSH_PUBKEY into authorized_keys and starts sshd
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 22
# This always runs when the container starts
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Need a long running daemon running in the foreground, or Docker will exit.
# Needs to listen continuously.
CMD ["/usr/sbin/sshd","-D","-e"]

