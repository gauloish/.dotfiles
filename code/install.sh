#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install VS Code
	sudo dnf copr enable elxreno/jetbrains-mono-fonts -y
	sudo dnf install jetbrains-mono-fonts -y

	log "Installing VS Code." "blue"
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
	
	echo " "
	log "VS Code Installed." "green"
