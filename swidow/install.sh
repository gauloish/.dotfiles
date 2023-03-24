#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Swidow

rm -rf $HOME/.dotfiles/swidow/packages/
mkdir $HOME/.dotfiles/swidow/packages/

#Reversl:
	log "Installing Swidow." "blue"
	git -C $HOME/.dotfiles/swidow/packages clone https://github.com/gauloish/swidow.git
	sh $HOME/.dotfiles/swidow/packages/swidow/install.sh -a -c

echo " "
log "Swidow Installed." "green"
