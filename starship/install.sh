#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Starship

#Starship:
	log "Installing Starship." "blue"
	curl -sS https://starship.rs/install.sh | sh

	echo " "
	log "Starship Installed." "green"

#----- Configure Starship

#Linkt:
	log "Linking Starship Configuration!" "yellow"
	rm $HOME/.config/starship.toml
	ln -s $HOME/.dotfiles/starship/starship.toml $HOME/.config/starship.toml

	echo " "
	log "Starship Configured." "green"

