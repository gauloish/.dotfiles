#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Fonts

rm -rf $REPO/fonts/packages
mkdir $REPO/fonts/packages

rm -rf $REPO/fonts/.fonts
mkdir $REPO/fonts/.fonts

#Nerd Fonts:
	log "Installing Nerd Fonts." "blue"
	echo " "
	
	url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"

	names[1]="Cascadia Cove"
	names[2]="Jet Brains"

	fonts[1]="CascadiaCode"
	fonts[2]="JetBrainsMono"

	for index in $(seq 2); do
		log "Installing ${names[$index]} Font." "blue"
		echo " "

		wget ${url}/${fonts[$index]}.tar.xz -P $REPO/fonts/packages/

		if [ $? -eq 0 ]; then
			mkdir $REPO/fonts/.fonts/${fonts[$index]}
			tar -xf $REPO/fonts/packages/${fonts[$index]}.tar.xz -C $REPO/fonts/.fonts/${fonts[$index]}/
		else
			log "Cascadia Cove Font Installation Failed!" "red"
		fi

		echo " "
	done

	fc-cache $HOME/.fonts

	log "Nerd Fonts Installed." "green"
	echo " "

#----- Configure Fonts

#Link:
	log "Linking Fonts!" "yellow"
	rm -rf $HOME/.fonts
	ln -s $REPO/fonts/.fonts $HOME/.fonts

	echo " "
	log "Nerd Fonts Configured." "green"
