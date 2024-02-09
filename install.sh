#!/bin/sh

REPO=$HOME/.dotfiles
CONF=$HOME/.config

URL=https://github.com/gauloish/.dotfiles

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

# ----- Updgrade System

# Upgrade:
	log "Upgrading System" "yellow"
	sudo dnf upgrade

# ----- Install Dependencies

# Utilitaries (Zip, Unzip, Wget, Curl and Git):
	log "Installing Utilitaries (Zip, Unzip, Wget, Curl and Git)." "magenta"
	sudo dnf install zip unzip wget curl git

# Setting Git:
	wget $URL/blob/main/git/.gitconfig

# Git Credential Manager:
	log "Installing Git Credential Manager." "magenta"
	curl -L https://aka.ms/gcm/linux-install-source.sh | sh
	git-credential-manager configure

	rm $REPO/dotnet-install.sh

# Create Dotfiles Directory:
	rm -r -f $REPO
	mkdir .dotfiles
	cd .dotfiles

# Initialize Git Repository:
	git init
 	git pull $URL
 	git remote add origin $URL
