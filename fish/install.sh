#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Fish

#Fish:
	log "Installing Fish." "blue"
	sudo dnf install -y fish

#----- Configure Fish

#Link:
	log "Linking Fish Configuration!" "yellow"

    if [ ! -d "$CONF/fish/" ]; then
        mkdir $CONF/fish
    fi

	rm -f $CONF/fish/config.fish
	ln -s $REPO/fish/config.fish $CONF/fish/config.fish

    if [ ! -d "$CONF/fish/functions/" ]; then
        mkdir $CONF/fish/functions
    fi

	rm -f $CONF/fish/functions/keymaps.fish
	ln -s $REPO/fish/keymaps.fish $CONF/fish/functions/keymaps.fish

	echo " "
	log "Fish Configured." "green"
