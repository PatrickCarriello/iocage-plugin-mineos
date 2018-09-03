#!/bin/sh

mkdir -p /usr/local/games
mkdir -p /usr/local/etc/rc.d

# Remove previous MineOS install
if [ -d "/usr/local/games/minecraft" ] ; then
  rm -rf /usr/local/games/minecraft
fi

# Clone source from official MineOS repository
cd /usr/local/games
git clone git://github.com/hexparrot/mineos-node minecraft 
if [ $? -ne 0 ] ; then
  echo "ERROR: Failed to get source from MineOS Repository"
  exit 1
fi
cd minecraft

# Create configuration file
if [ ! -f "/etc/mineos.conf" ] ; then
  # Option #1: Create standard configuration file
  # cp mineos.conf /etc/mineos.conf
  # Option #2: use http instead of the standard https
  sed 's/^use_https.*/use_https = false/' mineos.conf > /etc/mineos.conf
fi

# Build
echo "CXX=c++ npm install" | sh

# Enable the service
chmod +x *.sh
chmod +x /usr/local/etc/rc.d/mineos
sysrc -f /etc/rc.conf mineos_enable="YES"

# Start the service
service mineos start

service mineos status >/dev/null 2>&1
if [ $? -ne 0 ] ; then
  echo "ERROR: Failed to start service"
  exit 1
fi
