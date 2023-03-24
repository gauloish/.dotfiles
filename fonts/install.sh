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

	names[0]="Cascadia Cove"
	names[1]="Fantasque Sans"
	names[2]="Fira Code"
	names[3]="Hasklig"
	names[4]="Iosevka"
	names[5]="Jet Brains"
	names[6]="Lilex"
	names[7]="Monoid"
	names[8]="Victor"

	fonts[0]="CascadiaCode"
	fonts[1]="FantasqueSansMono"
	fonts[2]="FiraCode"
	fonts[3]="Hasklig"
	fonts[4]="Iosevka"
	fonts[5]="JetBrainsMono"
	fonts[6]="Lilex"
	fonts[7]="Monoid"
	fonts[8]="VictorMono"

	for index in 0 1 2 3 4 5 6 7 8; do
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

echo " "
log "Nerd Fonts Installed." "green"
