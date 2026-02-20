# This is a script to run on newely released linux VMs to:
# A) Create Users
# B) Add Users to admin Groups
# C) Change Hostname

# Variables required: USERNAME, HOSTNAME


# Variables provided check
if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Usage: $0 <username> <hostname>"
fi

USERNAME=$1
HOSTNAME=$2

# user creation
if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME exists."
else
    sudo useradd -m -d /home/"$USERNAME" -s /bin/bash "$USERNAME"
	sudo passwd $USERNAME
fi

# user elevation dependant on OS
if grep -qi "ubuntu\|debian" /etc/os-release; then
	SUDO_GROUP="sudo"
else
	SUDO_GROUP="wheel"
fi

sudo usermod -aG "$SUDO_GROUP" "$USERNAME" 

# hostname set
sudo hostnamectl set-hostname "$HOSTNAME"

# ubuntu detection for IP things
if grep -qi "ubuntu\|debian" /etc/os-release; then
	BACKUP_DIR="/etc/netplan/backups/$(date +%Y%m%d_%H%M%S)"
	mkdir -p "$BACKUP_DIR"
	cp /etc/netplan/*.yaml "$BACKUP_DIR/"

	# modify netplan file
	NETPLAN_FILE=$(ls /etc/netplan/*.yaml | head -1)
	sudo vi "$NETPLAN_FILE"
	sudo netplan apply

else
	# rocky open nmtui for network config
	sudo nmtui

fi

exit 0
