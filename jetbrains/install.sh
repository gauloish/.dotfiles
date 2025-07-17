#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Configure ToolBox

#Terminal:
	log "Configuring ToolBox." "blue"

	mkdir -p $HOME/.apps
	wget -O /tmp/jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?code=TBA&platform=linux"
	tar -xvzf /tmp/jetbrains-toolbox.tar.gz -C /tmp/

	EXTRACTED_DIR=$(find /tmp -maxdepth 1 -type d -name "jetbrains-toolbox-*")

	rm -rf $HOME/.apps/jetbrains-toolbox
	mv $EXTRACTED_DIR $HOME/.apps/jetbrains-toolbox/

	echo " "
	log "ToolBox Configured." "green"
