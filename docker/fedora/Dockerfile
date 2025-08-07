# Use Fedora 42 as the base image
FROM fedora:42

# Optional: Update and install some basic tools
RUN dnf -y update && \
    dnf -y install \
    bash \
    coreutils \
    util-linux \
    iproute \
    iputils \
    procps-ng \
    less \
    neovim \
    sudo \
    curl \
    && dnf clean all

# Set the working directory
WORKDIR /root

# Set the default shell
SHELL ["/bin/bash", "-c"]

# Start in interactive mode
CMD ["/bin/bash"]
