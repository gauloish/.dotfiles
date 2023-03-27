#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Fish

rm -rf $CONF/fish/
mkdir $CONF/fish/

#Fish:
	log "Installing Fish." "blue"
	sudo dnf install -y fish

#----- Configure Fish

#Link:
	log "Linking Fish Configuration!" "yellow"
	rm $CONF/fish/config.fish
	ln -s $REPO/fish/config.fish $CONF/fish/config.fish

	echo " "
	log "Fish Configured." "green"
