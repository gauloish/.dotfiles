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
	rm -f $CONF/zathura/zathurarc
	mkdir $CONF/zathura/
	ln -s $REPO/zathura/zathurarc $CONF/zathura/zathurarc

	echo " "
	log "Zathura Configured." "green"

