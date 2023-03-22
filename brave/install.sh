#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Brave

#Brave:
	log "Installing Brave." "blue"
	sudo dnf install -y dnf-plugins-core
	sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
	sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
	sudo dnf install -y brave-browser

echo " "
log "Brave Installed." "green"
