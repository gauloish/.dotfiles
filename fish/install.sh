#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Fish

#Git:
	log "Installing Fish." "blue"
	sudo dnf install fish

#----- Configure Fish

#Link:
	log "Linking Fish Configuration!" "yellow"
	rm $CONF/fish/config.fish
	ln -s $REPO/fish/config.fish $CONF/fish/config.fish

	echo " "
	log "Fish Configured." "green"
