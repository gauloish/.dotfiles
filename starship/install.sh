#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Starship

#Starship:
	log "Installing Starship." "blue"
	curl -sS https://starship.rs/install.sh | sh

echo " "
log "Starship Installed." "green"
