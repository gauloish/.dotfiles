#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install VS Code
	log "Installing Python and Utilitaries." "blue"
	sudo dnf install -y python
	sudo dnf install -y pip

	pip install pylance
	pip install flake8
	pip install mypy
	pip install black
	pip install isort

	log "Installing JetBrains Font." "blue"
	sudo dnf copr enable elxreno/jetbrains-mono-fonts -y
	sudo dnf install jetbrains-mono-fonts -y

	log "Installing VS Code." "blue"
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
    sudo dnf install -y code
	
	echo " "
	log "VS Code Installed." "green"
