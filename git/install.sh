#!/bin/sh

#----- Install Git

#Git:
	echo "Installing Git."
	sudo dnf install git

#Git Credential Manager:
	echo "Installing Git Credential Manager."
	curl -L https://aka.ms/gcm/linux-install-source.sh | sh
