#!/bin/sh

source $HOME/.dotfiles/utils.sh

BASE=/usr/share/icons/hicolor/scalable/apps
ICON=org.gnome.Ptyxis.svg

#----- Configure Terminal

#Terminal:
	log "Configuring Terminal." "blue"

	sudo rm -f $BASE/$ICON
	sudo ln -s $REPO/terminal/icons/$ICON $BASE/$ICON

	echo " "
	log "Terminal Configured." "green"

