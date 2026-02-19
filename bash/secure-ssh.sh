# secure-ssh.sh
# author logan
# creates a new ssh user using $1 parameter
# adds a public key from local repo or curled from remote repo
# removes root ability to ssh in

#!/bin/bash

# username provided check
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME=$1

# create user with home dir
sudo useradd -m -d /home/$USERNAME -s /bin/bash "$USERNAME"

# make ssh dir
sudo mkdir /home/$USERNAME/.ssh

# copy key
sudo cp $HOME/SYS-265-Logan-S/linux/public-keys/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys

#set perms
sudo chmod 700 /home/$USERNAME/.ssh
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys && sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# Block Root SSH
#if grep -q "^PermitRootLogin" /etc/ssh/sshd_config; then
#   sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
#else
#   echo "PremitRootLogin not found in /etc/ssh/sshd_config"
#fi

# restart ssh
sudo systemctl restart ssh
