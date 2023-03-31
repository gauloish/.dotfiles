#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Fish

#Fish:
	log "Installing Fish." "blue"
	sudo dnf install -y fish

#----- Configure Fish

#Link:
	log "Linking Fish Configuration!" "yellow"
	rm $CONF/fish/config.fish
	ln -s $REPO/fish/config.fish $CONF/fish/config.fish

	mkdir $CONF/fish/functions/
	rm $CONF/fish/functions/keymaps.fish
	ln -s $REPO/fish/keymaps.fish $CONF/fish/functions/keymaps.fish

	echo " "
	log "Fish Configured." "green"
