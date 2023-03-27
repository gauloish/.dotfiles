#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Updgrade System

#Upgrade:
	log "Upgrading System" "yellow"
	sudo dnf upgrade

#----- Install Dependencies

#Zip:
	log "Installing Zip" "magenta"
	sudo dnf install zip

#Unzip:
	log "Installing Unzip" "magenta"
	sudo dnf install unzip

#Wget:
	log "Installing Wget" "magenta"
	sudo dnf install wget

#Curl:
	log "Installing Curl" "magenta"
	sudo dnf install curl

#----- Install and Setup Softwares

source $HOME/.dotfiles/git/install.sh
source $HOME/.dotfiles/starship/install.sh
source $HOME/.dotfiles/fish/install.sh
source $HOME/.dotfiles/blackbox/install.sh
source $HOME/.dotfiles/neovim/install.sh
source $HOME/.dotfiles/fonts/install.sh
source $HOME/.dotfiles/orchis/install.sh
source $HOME/.dotfiles/swidow/install.sh
source $HOME/.dotfiles/zathura/install.sh
source $HOME/.dotfiles/brave/install.sh
source $HOME/.dotfiles/chrome/install.sh
