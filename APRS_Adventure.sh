#!/bin/bash

# Debian 12 Installer Script for Xaster, DireWolf, and YAAC created by Freddie Mac - KD5FMU and ChatGPT

# Function to print colored messages
print_message() {
  echo -e "\033[1;32m$1\033[0m"
}

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

print_message "Updating the system..."
apt update && apt upgrade -y

# Install required dependencies
print_message "Installing dependencies..."
apt install -y openjdk-11-jre default-jre build-essential git cmake libasound2-dev portaudio19-dev libusb-1.0-0-dev wget

# Install Xaster
print_message "Installing Xaster..."
wget -O xaster.deb https://xaster.com/latest.deb  # Replace with the correct URL for Xaster
if [ -f xaster.deb ]; then
  dpkg -i xaster.deb
  apt-get install -f -y  # Fix missing dependencies
else
  echo "Xaster installation file not found!"
fi

# Install DireWolf
print_message "Installing DireWolf..."
if [ ! -d "direwolf" ]; then
  git clone https://www.github.com/wb2osz/direwolf.git
fi
cd direwolf || exit
mkdir build && cd build || exit
cmake ..
make
make install
make install-conf
cd ../.. || exit

# Install YAAC
print_message "Installing YAAC..."
wget -O yaac.zip http://www.ka2ddo.org/ka2ddo/YAAC.zip
if [ -f yaac.zip ]; then
  unzip yaac.zip -d /opt/yaac
  chmod +x /opt/yaac/yaac.jar
  ln -s /opt/yaac/yaac.jar /usr/local/bin/yaac
else
  echo "YAAC installation file not found!"
fi

# Final cleanup
print_message "Cleaning up..."
rm -f xaster.deb yaac.zip
apt autoremove -y

print_message "Installation complete!"
print_message "You can start the programs using their commands:"
print_message " - Xaster"
print_message " - DireWolf (configure /etc/direwolf.conf as needed)"
print_message " - YAAC (java -jar /opt/yaac/yaac.jar)"
