#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Fonts

rm -rf $HOME/.dotfiles/fonts/packages/
mkdir $HOME/.dotfiles/fonts/packages/

rm -rf $HOME/.dotfiles/fonts/.fonts/
mkdir $HOME/.dotfiles/fonts/.fonts/

#Nerd Fonts:
	log "Installing Nerd Fonts." "blue"
	echo " "
	
	version="v2.3.3"
	url="https://github.com/ryanoasis/nerd-fonts/releases/download"

	names[1]="Cascadia Cove"
	names[2]="Fantasque Sans"
	names[3]="Fira Code"
	names[4]="Hasklig"
	names[5]="Iosevka"
	names[6]="Jet Brains"
	names[7]="Lilex"
	names[8]="Monoid"
	names[9]="Victor"

	fonts[1]="CascadiaCode"
	fonts[2]="FantasqueSansMono"
	fonts[3]="FiraCode"
	fonts[4]="Hasklig"
	fonts[5]="Iosevka"
	fonts[6]="JetBrainsMono"
	fonts[7]="Lilex"
	fonts[8]="Monoid"
	fonts[9]="VictorMono"

	for index in $(seq 9); do
		log "Installing ${names[$index]} Font." "blue"
		echo " "

		wget ${url}/${version}/${fonts[$index]}.zip -P $HOME/.dotfiles/fonts/packages/

		if [ $? -eq 0 ]; then
			mkdir $HOME/.dotfiles/fonts/.fonts/${fonts[$index]}
			unzip $HOME/.dotfiles/fonts/packages/${fonts[$index]}.zip -d $HOME/.dotfiles/fonts/.fonts/${fonts[$index]}/
		else
			log "Cascadia Cove Font Installation Failed!" "red"
		fi
	done

	fc-cache $HOME/.fonts

	echo " "
	log "Nerd Fonts Installed." "green"

#----- Configure Fonts

#Link:
	log "Linking Fonts!" "yellow"
	rm -r $HOME/.fonts
	ln -s $HOME/.dotfiles/fonts/.fonts $HOME/.fonts

	echo " "
	log "Nerd Fonts Configured." "green"
