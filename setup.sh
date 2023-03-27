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

source $REPO/git/install.sh
source $REPO/starship/install.sh
source $REPO/fish/install.sh
source $REPO/blackbox/install.sh
source $REPO/neovim/install.sh
source $REPO/fonts/install.sh
source $REPO/orchis/install.sh
source $REPO/swidow/install.sh
source $REPO/zathura/install.sh
source $REPO/brave/install.sh
source $REPO/chrome/install.sh
