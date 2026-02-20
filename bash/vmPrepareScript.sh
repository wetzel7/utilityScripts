# This is a script to run on newely released linux VMs to:
# A) Create Users
# B) Add Users to admin Groups
# C) Change Hostname

# Variables required: USERNAME, HOSTNAME


# Get variables from user
read -r -p "Enter a username and hostname for the VM seperated by spaces: " USERNAME HOSTNAME

# Check user input
if [ -z "$USERNAME" ] || [ -z "$HOSTNAME" ]; then
    echo "Usage: please provide a username and hostname"
    exit 1
fi

# user creation
if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME exists."
else
    sudo useradd -m -d /home/"$USERNAME" -s /bin/bash "$USERNAME"
	sudo passwd "$USERNAME"
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
	# Backups for netplan directory YAMLs
	BACKUP_DIR="/etc/netplan/backups/$(date +%Y%m%d_%H%M%S)"
	mkdir -p "$BACKUP_DIR"
	cp /etc/netplan/*.yaml "$BACKUP_DIR/"
	# modify netplan file
	NETPLAN_FILE=$(find /etc/netplan -maxdepth 1 -name "*.yaml" | head -1)

	while true; do
		sudo vi "$NETPLAN_FILE"
		if sudo netplan try; then
			echo "config GUD"
			sudo netplan apply
			break
		else
			echo "netplan borked kid, try again"
			sleep 5
		fi
	done
	
else
	# rocky open nmtui for network config
	sudo nmtui

fi

exit 0
