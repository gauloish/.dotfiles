#!/bin/sh

REPO=$HOME/.dotfiles
CONF=$HOME/.config

log() {
	declare -A colors

	colors["black"]="\033[30m"
	colors["red"]="\033[31m"
	colors["green"]="\033[32m"
	colors["yellow"]="\033[33m"
	colors["blue"]="\033[34m"
	colors["magenta"]="\033[35m"
	colors["cyan"]="\033[36m"
	colors["white"]="\033[37m"
	colors["default"]="\033[39m"

	colors["end"]="\033[0m"

	echo -e "${colors[$2]}$1${colors["end"]}"
}

# Stay Home:
    cd $HOME

#----- Updgrade System

#Upgrade:
	log "Upgrading System" "yellow"
	sudo dnf upgrade

#----- Install Dependencies

#Zip:
	log "Installing Zip." "magenta"
	sudo dnf install zip

#Unzip:
	log "Installing Unzip." "magenta"
	sudo dnf install unzip

#Wget:
	log "Installing Wget." "magenta"
	sudo dnf install wget

#Curl:
	log "Installing Curl." "magenta"
	sudo dnf install curl

#Git:
	log "Installing Git." "magente"
	sudo dnf install git

#Git Credential Manager:
	log "Installing Git Credential Manager." "magenta"
	curl -L https://aka.ms/gcm/linux-install-source.sh | sh
	git-credential-manager configure

	rm $REPO/dotnet-install.sh

# Create Dotfiles Directory:
    rm -f $REPO
    mkdir .dotfiles
    cd .dotfiles

# Initialize Git Repository:
	git init
 	git pull https://github.com/gauloish/.dotfiles
