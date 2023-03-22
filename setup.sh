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

#----- Install Softwares

source $HOME/.dotfiles/git/install.sh
source $HOME/.dotfiles/zshell/install.sh
source $HOME/.dotfiles/starship/install.sh
source $HOME/.dotfiles/wezterm/install.sh
source $HOME/.dotfiles/neovim/install.sh
source $HOME/.dotfiles/fonts/install.sh
source $HOME/.dotfiles/zathura/install.sh
source $HOME/.dotfiles/brave/install.sh

#----- Link Softwares

log "Linking Fonts!" "yellow"
rm $HOME/.fonts
ln -s $HOME/.dotfiles/fonts/.fonts $HOME/.fonts/

log "Linking Git Config!" "yellow"
rm $HOME/.gitconfig
ln -s $HOME/.dotfiles/git/.gitconfig $HOME/.gitconfig

log "Linking Starship Config!" "yellow"
rm $HOME/.config/starship.toml
ln -s $HOME/.dotfiles/starship/starship.toml $HOME/.config/starship.toml

log "Linking Zshell Config!" "yellow"
rm $HOME/.zshrc
ln -s $HOME/.dotfiles/zshell/.zshrc $HOME/.zshrc

log "Linking Wezterm Config!" "yellow"
rm $HOME/.wezterm.lue
ln -s $HOME/.dotfiles/wezterm/.wezterm.lua $HOME/.wezterm.lua

log "Linking Neovim Config!" "yellow"
rm $HOME/.config/nvim
ln -s $HOME/.dotfiles/neovim/nvim $HOME/.config/nvim

log "Linking Zathura Config!" "yellow"
rm $HOME/.config/zathura/zathurarc
ln -s $HOME/.dotfiles/zathura/zathurarc $HOME/.config/zathura/zathurarc
