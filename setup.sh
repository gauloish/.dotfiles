#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Updgrade System

#Upgrade:
	log "Upgrading System" "yellow"
	sudo dnf upgrade

#----- Install and Setup Softwares

source $REPO/neovim/install.sh
source $REPO/code/install.sh
source $REPO/starship/install.sh
source $REPO/fish/install.sh
source $REPO/fonts/install.sh
source $REPO/orchis/install.sh
source $REPO/swidow/install.sh
source $REPO/terminal/install.sh
source $REPO/jetbrains/install.sh
source $REPO/chrome/install.sh
