FROM fedora:latest

# Add everything from build directory ~/Coding/Ansible/docker-build to container ~/
ADD ./ ./root/

# apt updates and install ansible, curl, git, neovim
RUN dnf update -y && dnf install -y gcc g++ curl git ansible neovim vim zsh wget nodejs npm lua luarocks

# install ohmyzsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# delete extra files
RUN cd /root/ && rm ana* original-ks.cfg .cshrc .tcshrc .bash_logout .bash_profile .viminfo

CMD ["zsh"]
