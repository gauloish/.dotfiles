#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Zathura

#Zathura:
	log "Installing Zathura." "blue"
	sudo dnf install -y zathura

	echo " "
	log "Zathura Installed." "green"

#----- Configure Zathura

#Link:
	log "Linking Zathura Configuration!" "yellow"
	rm $HOME/.config/zathura/zathurarc
	mkdir $HOME/.config/zathura/
	ln -s $HOME/.dotfiles/zathura/zathurarc $HOME/.config/zathura/zathurarc

	echo " "
	log "Zathura Configured." "green"

