#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Dependencies

theme="-Dracula"

rm -rf $REPO/orchis/packages/
mkdir $REPO/orchis/packages/

rm -rf $HOME/.themes/
mkdir $HOME/.themes/

rm -rf $CONF/gtk-4.0

#Dependencies:
	log "Installing Orchis Dependencies." "blue"
	sudo dnf install -y gnome-themes-extra
	sudo dnf install -y gnome-tweaks
	sudo dnf install -y gnome-extensions-app
	sudo dnf install -y gnome-shell-extension-user-theme
	sudo dnf install -y gnome-shell-extension-blur-my-shell
	sudo dnf install -y gtk-murrine-engine
	sudo dnf install -y sassc

#----- Install Orchis

#Orchis:
	log "Installing Orchis." "blue"
	git -C $REPO/orchis/packages clone https://github.com/vinceliuice/Orchis-theme.git
	sh $REPO/orchis/packages/Orchis-theme/install.sh --uninstall
	sh $REPO/orchis/packages/Orchis-theme/install.sh --theme default grey --size standard --tweaks solid compact --libadwaita --shell 42
	sh $REPO/orchis/packages/Orchis-theme/install.sh --theme default grey --size standard --tweaks solid compact nord --libadwaita --shell 42
	sh $REPO/orchis/packages/Orchis-theme/install.sh --theme default grey --size standard --tweaks solid compact dracula --libadwaita --shell 42

	rm -rf $CONF/gtk-4.0/assets
	rm -rf $CONF/gtk-4.0/gtk.css
	rm -rf $CONF/gtk-4.0/gtk-dark.css

	ln -s $HOME/.themes/Orchis-Grey-Dark${theme}/gtk-4.0/assets $CONF/gtk-4.0/assets
	ln -s $HOME/.themes/Orchis-Grey-Dark${theme}/gtk-4.0/gtk.css $CONF/gtk-4.0/gtk.css
	ln -s $HOME/.themes/Orchis-Grey-Dark${theme}/gtk-4.0/gtk-dark.css $CONF/gtk-4.0/gtk-dark.css

echo " "
log "Orchis Installed." "green"
