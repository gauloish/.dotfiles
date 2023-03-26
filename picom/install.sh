#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Picom

#Picom:
	log "Installing Picom." "blue"
	sudo dnf install -y picom

	echo " "
	log "Picom Installed." "green"

#----- Configure Picom

#Link:
	log "Linking Picom Configuration!" "yellow"
	rm $HOME/.config/picom/picom.conf
	mkdir $HOME/.config/picom/
	ln -s $HOME/.dotfiles/picom/picom.conf $HOME/.config/picom/picom.conf

	echo " "
	log "Picom Configured." "green"
