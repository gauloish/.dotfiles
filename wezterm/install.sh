#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Wezterm

#Wezterm:
	log "Installing Wezterm." "blue"
	sudo dnf install -y https://github.com/wez/wezterm/releases/download/20230320-124340-559cb7b0/wezterm-20230320_124340_559cb7b0-1.fedora37.x86_64.rpm

	sudo rm -f /usr/share/icons/hicolor/128x128/apps/org.wezfurlong.wezterm.png
	sudo mv $REPO/wezterm/icon.png $REPO/wezterm/org.wezfurlong.wezterm.png
	sudo cp $REPO/wezterm/org.wezfurlong.wezterm.png /usr/share/icons/hicolor/128x128/apps
	sudo mv $REPO/wezterm/org.wezfurlong.wezterm.png $REPO/wezterm/icon.png 

	echo " "
	log "Wezterm Installed." "green"

#----- Configure Wezterm

#Link:
	log "Linking Wezterm Configuration!" "yellow"
	rm $HOME/.wezterm.lua
	ln -s $REPO/wezterm/.wezterm.lua $HOME/.wezterm.lua

	echo " "
	log "Wezterm Configured." "green"

