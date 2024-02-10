#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Updgrade System

#Upgrade:
	log "Upgrading System" "yellow"
	sudo dnf upgrade

#----- Install and Setup Softwares

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
