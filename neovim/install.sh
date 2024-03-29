#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Neovim

#Neovim:
	log "Installing Neovim." "blue"
	sudo dnf install -y neovim
	sudo dnf install -y python3-neovim

#----- Install Dependencies

#C++:
	log "Installing C++ Dependencies." "blue"
	sudo dnf install gcc-c++

#Python:
	log "Installing Python Dependencies." "blue"
	sudo dnf install -y python
	sudo dnf install -y pip
	pip install pynvim
	pip install yarp

#Node:
	log "Installing Node Dependencies." "blue"
	sudo dnf install -y nodejs
	sudo dnf install -y npm

#Rust:
	log "Installing Rust Dependencies." "blue"
	sudo dnf install -y rust
	sudo dnf install -y cargo

#Lua:
	log "Installing Lua Dependencies." "blue"
	sudo dnf install -y lua
	sudo dnf install -y luarocks

#Latex:
	log "Installing Latex Dependencies" "blue"
	sudo dnf install -y texlive-scheme-basic

#Utilitary:
	log "Installing Some Utilitaries." "blue"
	sudo dnf install -y ripgrep
	sudo dnf install -y fd-find

	echo " "
	log "Neovim and All Dependencies Installed." "green"

#----- Configure Neovim

	log "Linking Neovim Configuration!" "yellow"
    rm -rf ~/.config/nvim
    rm -rf ~/.local/share/nvim

#Nv Chad:
	log "Installing Nv Chad Configuration" "blue"
  git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

#Link:
	rm -rf $CONF/nvim/lua/custom
	ln -s $REPO/neovim/custom $CONF/nvim/lua/custom

	echo " "
	log "Neovim Configured." "green"
