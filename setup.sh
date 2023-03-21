#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Updgrade System

#Upgrade:
	log "Upgrading System" "yellow"
	sudo dnf upgrade

#----- Install Dependencies

#Zip:
	log "Installing Zip" "magenta"
	sudo dnf install zip

#Unzip:
	log "Installing Unzip" "magenta"
	sudo dnf install unzip

#Wget:
	log "Installing Wget" "magenta"
	sudo dnf install wget

#Curl:
	log "Installing Curl" "magenta"
	sudo dnf install curl
