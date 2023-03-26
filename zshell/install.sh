#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Zshell

#Zshell:
	log "Installing Zshell." "blue"
	sudo dnf install -y zsh

	log "Changing Default Shell to Zshell" "cyan"
	chsh -s $(which zsh)

	echo " "
	log "Zshell Installed." "green"

#----- Configure Zshell

#Link:
	log "Linking Zshell Configuration!" "yellow"
	rm $HOME/.zshrc
	ln -s $HOME/.dotfiles/zshell/.zshrc $HOME/.zshrc

	echo " "
	log "Zshell Configured." "green"
