#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Zathura

#Zathura:
	log "Installing Zathura." "blue"
	sudo dnf install zathura

echo " "
log "Zathura Installed." "green"