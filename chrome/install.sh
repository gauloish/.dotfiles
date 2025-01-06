#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Chrome

#Chrome:
	log "Installing Chrome." "blue"
	sudo dnf install -y fedora-workstation-repositories
	sudo dnf install -y google-chrome-stable

echo " "
log "Chrome Installed." "green"
