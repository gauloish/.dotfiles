#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Kitty

#Kitty:
	log "Installing Kitty." "blue"
	sudo dnf install -y kitty

	sudo rm -f /usr/share/icons/hicolor/64x64/apps/kitty.png
	sudo cp $REPO/kitty/icons/64x64/kitty.png /usr/share/icons/hicolor/64x64/apps/kitty.png

	sudo rm -f /usr/share/icons/hicolor/128x128/apps/kitty.png
	sudo cp $REPO/kitty/icons/128x128/kitty.png /usr/share/icons/hicolor/128x128/apps/kitty.png

	sudo rm -f /usr/share/icons/hicolor/256x256/apps/kitty.png
	sudo cp $REPO/kitty/icons/256x256/kitty.png /usr/share/icons/hicolor/256x256/apps/kitty.png

	sudo rm -f /usr/share/icons/hicolor/scalable/apps/kitty.svg
	sudo cp $REPO/kitty/icons/scalable/kitty.svg /usr/share/icons/hicolor/scalable/apps/kitty.svg

	echo " "
	log "Kitty Installed." "green"

#----- Configure Kitty

#Link:
	log "Linking Kitty Configuration!" "yellow"
	rm $CONF/kitty/kitty.conf
	mkdir $CONF/kitty/
	ln -s $REPO/kitty/kitty.conf $CONF/kitty/kitty.conf

	echo " "
	log "Kitty Configured." "green"