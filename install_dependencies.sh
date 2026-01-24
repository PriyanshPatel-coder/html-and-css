#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root (use sudo)"
  exit
fi

echo "Updating package lists..."
apt-get update

echo "Installing ImageMagick..."
apt-get install -y imagemagick

echo "Installation complete!"
echo "You can now use the resize_image.sh script."
