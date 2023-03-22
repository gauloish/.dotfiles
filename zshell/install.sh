#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Zshell

#Zshell:
	log "Installing Zshell." "blue"
	sudo dnf install zsh

	log "Changing Default Shell to Zshell" "cyan"
	chsh -s $(which zsh)

echo " "
log "Zshell Installed." "green"
