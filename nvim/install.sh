#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Neovim

#Neovim:
	log "Installing Neovim." "blue"
	sudo dnf install neovim
	sudo dnf install python3-neovim

#----- Install Dependencies

#C++:
	log "Installing C++ Dependencies." "blue"
	sudo dnf install gcc-c++

#Python:
	log "Installing Python Dependencies." "blue"
	sudo dnf install python
	sudo dnf install pip
	pip install pynvim
	pip install yarp

#Node:
	log "Installing Node Dependencies." "blue"
	sudo dnf install nodejs
	sudo dnf install npm

#Rust:
	log "Installing Rust Dependencies." "blue"
	sudo dnf install rust
	sudo dnf install cargo

#Lua:
	log "Installing Lua Dependencies." "blue"
	sudo dnf install lua
	sudo dnf install luarocks

#Latex:
	log "Installing Latex Dependencies" "blue"
	sudo dnf install texlive-scheme-full

#Utilitary:
	log "Installing Soma Utilitaries." "blue"
	sudo dnf install ripgrep
	sudo dnf install fd-find

echo " "
log "Neovim and All Dependencies Installed." "green"
