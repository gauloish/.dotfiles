#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Swidow

rm -rf $REPO/swidow/packages/
mkdir $REPO/swidow/packages/

#Reversl:
	log "Installing Swidow." "blue"
	git -C $REPO/swidow/packages clone https://github.com/gauloish/swidow.git
	sh $REPO/swidow/packages/swidow/install.sh -a -c

echo " "
log "Swidow Installed." "green"
