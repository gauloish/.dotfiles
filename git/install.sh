#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Git

#Git:
	log "Installing Git." "blue"
	sudo dnf install git

#Git Credential Manager:
	log "Installing Git Credential Manager." "blue"
	#curl -L https://aka.ms/gcm/linux-install-source.sh | sh

rm $HOME/.dotfiles/dotnet-install.sh

echo " "
log "Git and All Dependencies Installed." "green"
