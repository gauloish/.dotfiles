#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Blackbox

HEAD=/var/lib/flatpak/app/com.raggesilver.BlackBox
FORK=share/icons/hicolor/scalable/apps
FILE=com.raggesilver.BlackBox

#Dependencies:
	log "Setup Flatpak to Use Flathub." "blue"
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#Blackbox:
	log "Installing BlackBox." "blue"
	flatpak install flathub com.raggesilver.BlackBox

	log "Changing BlackBox Icons." "blue"

	sudo cp $HOME/.dotfiles/blackbox/icons/${FILE}.svg $HEAD/x86_64/stable/active/export/${FORK}/${FILE}.svg
	sudo cp $HOME/.dotfiles/blackbox/icons/${FILE}.svg $HEAD/x86_64/stable/active/files/${FORK}/${FILE}.svg

	echo " "
	log "BlackBox Installed." "green"
