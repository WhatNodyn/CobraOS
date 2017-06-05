#!/bin/bash

echo -e "\n\n#####################################\n#   STARTING CUSTOMIZATION SCRIPT   #\n#####################################\n\n"

set -e -u

sed -Ei 's/#((en_US|fr_FR)\.UTF-8)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

# Create and configure users
usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root

useradd -mU -s /usr/bin/zsh student
useradd -mUG wheel -s /usr/bin/zsh cobra

chpasswd < /root/passwords
rm /root/passwords

# Allow the wheel group to use sudo
sed -i 's/# \(%wheel ALL=(ALL) NOPASSWD: ALL\)/\1/' /etc/sudoers

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

# Disable power keys
sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service nodm.service hostname.service NetworkManager.service
systemctl set-default multi-user.target

echo -e "\n\n#####################################\n#     CUSTOMIZATION SCRIPT DONE     #\n#####################################\n\n"
