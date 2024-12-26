#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

# Update the package list
apt-get update

# Install required packages
apt-get install -y ca-certificates curl

# Create the directory for the Docker GPG key if it doesn't exist
install -m 0755 -d /etc/apt/keyrings

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package list after adding Docker repository
apt-get update

# Install Docker packages
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Test Docker installation
docker run hello-world

# Add the current user to the Docker group
usermod -aG docker $SUDO_USER

# Install additional X server utilities
apt-get install -y xpra xserver-xephyr xinit xauth xclip x11-xserver-utils x11-utils

# Install and update x11docker
curl -fsSL https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker | bash -s -- --update

# Update x11docker
x11docker --update

echo "Docker and x11docker have been installed and configured successfully."

