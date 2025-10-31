#!/bin/bash

# Jeremy Villa's setup: https://pathrobotics.atlassian.net/wiki/spaces/~352604994/pages/3174138065/TigerVNC+setup#Intro, but scripted

if command -v vncserver >/dev/null 2>&1; then
  exit 0
fi

architecture="$(dpkg --print-architecture)"
expected_md5_version_1_15_0="09f5abedb610b7e13e9662ec13e98a64"
tigervnc_version="1.15.0"
ubuntu_version="$(lsb_release -sr)"

download_link="https://downloads.sourceforge.net/project/tigervnc/stable/${tigervnc_version}/ubuntu-${ubuntu_version}LTS/${architecture}/tigervncserver_${tigervnc_version}-1ubuntu1_${architecture}.deb"
file_name="tigervncserver_${tigervnc_version}-1ubuntu1_${architecture}.deb"

echo "Installing TigerVNC version ${tigervnc_version} for Ubuntu ${ubuntu_version} (${architecture})"

sudo apt install gnome-session -y
curl -sLO $download_link

actual_md5="$(md5sum $file_name | awk '{print $1}')"
expected_md5=$expected_md5_version_1_15_0

if [[ "$actual_md5" != "$expected_md5" ]]; then
  echo "TigerVNC download failed for md5 mismatch. Exiting"
  exit 1
fi

# Install
sudo dpkg --install $file_name && rm $file_name

# Allocate a display number for your user
user=:2=$(whoami)
sudo grep -qxF "$user" /etc/tigervnc/vncserver.users || echo "$user" | sudo tee --append /etc/tigervnc/vncserver.users >/dev/null

# Config
mkdir -p ~/.config/tigervnc
echo -e "session=gnome\nsecuritytypes=none\ngeometry=1920x1080\nlocalhost\nalwaysshared\nlog=*:syslog:100" | sudo tee ~/.config/tigervnc/config >/dev/null

# Start your VNC server
sudo systemctl start vncserver@:2
sudo systemctl enable vncserver@:2
