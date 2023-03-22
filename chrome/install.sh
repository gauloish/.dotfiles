#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Chrome

#Chrome:
	log "Installing Google Chrome." "blue"
	sudo dnf install -y fedora-workstation-repositories
	sudo dnf config-manager --set-enabled google-chrome
	sudo dnf install -y google-chrome-stable

echo " "
log "Google Chrome Installed." "green"
