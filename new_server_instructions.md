# Server Setup Checklist

## CentOS 10 / Fedora Server
*Do all this on the server*

Update + essentials

- `sudo dnf -y update`
- `sudo dnf -y install vim curl git tmux openssh-server policycoreutils-python-utils`

#### Enable SSH server (if not already)
`sudo systemctl enable --now sshd`

#### Create your user (if needed) and add to wheel
`sudo useradd -m -s /bin/bash kbitson`
`sudo passwd bittysANDboppies`  <!-- set a strong temp password (you'll disable SSH passwords later) -->
`sudo usermod -aG wheel kbitson`

#### (Optional) Set hostname
sudo hostnamectl set-hostname <hostname>

---
---

*You can do the rest on your local machine*
## Use Ansible

#### Remote into box, to commit pubkey as known host
`ssh-copy-id user@hostip`

#### Add your ansible server to install stuff on

[servers]
bitson ansible_host=192.168.1.116 ansible_user=kbitson ansible_python_interpreter=/usr/bin/python3

then run the playbook: `ansible-playbook centOS-setup.yml -K` the -K is to have root priviledge when
needed


#### SSH hardening (security so no one can ssh in with password, only keypair)


make a backup first

`sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak`

then, in sshd_config:  
```
PubkeyAuthentication yes
PasswordAuthentication no

PermitRootLogin prohibit-password
AuthenticationMethods publickey
# AllowUsers kbitson    # uncomment to whitelist specific users
```

and restart:  
`sudo systemctl restart sshd`

#### mDNS and ssh through firewall

```
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=mdns    # for Avahi/mDNS
sudo firewall-cmd --reload
sudo firewall-cmd --list-services
```

#### Advertise hostname.local through avahi

```
sudo dnf -y install avahi
sudo systemctl enable --now avahi-daemon
```

```
sudo mkdir -p /etc/avahi/services
sudo tee /etc/avahi/services/ssh.service >/dev/null <<'XML'
<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
  <name replace-wildcards="yes">%h</name>
  <service>
    <type>_ssh._tcp</type>
    <port>22</port>
  </service>
  <service>
    <type>_sftp-ssh._tcp</type>
    <port>22</port>
  </service>
</service-group>
XML
```

`sudo systemctl restart avahi-daemon`

#### Test mDNS resolution on mac

```
dns-sd -B _ssh
dns-sd -L bitson _ssh _tcp local
ssh kbitson@bitson.local
```


Note: Maybe in the future this whole process cna be done through ansible?? Automate the entire
process perhaps. 
