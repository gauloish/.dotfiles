#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Wezterm

#Wezterm:
	log "Installing Wezterm." "blue"
	sudo dnf install -y https://github.com/wez/wezterm/releases/download/20230320-124340-559cb7b0/wezterm-20230320_124340_559cb7b0-1.fedora37.x86_64.rpm

echo " "
log "Wezterm Installed." "green"
