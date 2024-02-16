#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Dependencies

rm -rf $REPO/orchis/packages
mkdir $REPO/orchis/packages

rm -rf $HOME/.themes
mkdir $HOME/.themes

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
	sh $REPO/orchis/packages/Orchis-theme/install.sh --theme default grey --size standard --tweaks solid compact submenu --shell 44
	#sh $REPO/orchis/packagess/Orchis-theme/install.sh --theme default grey --size standard --tweaks solid compact submenu nord --libadwaita --shell 44
	#sh $REPO/orchis/packagess/Orchis-theme/install.sh --theme default grey --size standard --tweaks solid compact submenu dracula --libadwaita --shell 44
  
    sh $REPO/orchis/theme.sh Grey

echo " "
log "Orchis Installed." "green"
