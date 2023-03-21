#!/bin/sh

# Install Neovim

#Neovim:
	echo "Installing Neovim."
	sudo dnf install neovim
	sudo dnf install python3-neovim

# Install Dependencies

#C++:
	echo "Installing C++ Dependencies."
	sudo dnf install gcc-c++

#Python:
	echo "Installing Python Dependencies."
	sudo dnf install python
	sudo dnf install pip
	pip install pynvim
	pip install yarp

#Node:
	echo "Installing Node Dependencies."
	sudo dnf install nodejs
	sudo dnf install npm

#Rust:
	echo "Installing Rust Dependencies."
	sudo dnf install rust
	sudo dnf install cargo

#Lua:
	echo "Installing Lua Dependencies."
	sudo dnf install lua
	sudo dnf install luarocks

#Latex:
	echo "Installing Latex Dependencies"
	sudo dnf install texlive-scheme-full

#Utilitary:
	echo "Installing Soma Utilitaries."
	sudo dnf install ripgrep
	sudo dnf install fd-find

echo " "
echo "Neovim and All Dependencies Installed."
