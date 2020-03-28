#!/bin/bash
export WIN_USERNAME=$(powershell.exe '$env:UserName')

# Get SSH keys from Windows environment 
umask 077
if [ ! -d ~/.ssh ]
then
  cp -r /mnt/c/Users/flori/.ssh ~/
  chmod 600 ~/.ssh/config
  chmod 400 ~/.ssh/id*
fi

# Setup SSH agent, umask, aliases and prompt
if [ -z "$WSL_SETUP_EXECUTED" ] #only concat once
then
  cat ./ssh-scripts >> ~/.profile
  cat ./aliases >> ~/.bash_aliases
  cat ./prompt.bash >> ~/.bashrc
  echo export WSL_SETUP_EXECUTED=true >> ~/.bashrc
fi

# Import settings for git and vim
cp vimrc ~/.vimrc
cp gitconfig ~/.gitconfig

## Debian Specific stuff
# Install packages, for Debian like environments
sudo apt update -y
sudo apt upgrade -y
sudo apt install curl vim openssh-client git man-db -y
# Repo clean up
sudo apt autoremove --purge -y
sudo apt clean all

## Debian specific stuff ends here

# Let SSH not bother me everytime I connect to a new host, which happens a lot.
sudo sed -i "s/#   StrictHostKeyChecking ask/    StrictHostKeyChecking no/g" /etc/ssh/ssh_config

# Passwordless sudo
echo "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers" | sudo bash

# Delete this repo
  ## rm -rf ~/wsl-setup

exit 0
