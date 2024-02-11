#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Fonts

rm -rf $REPO/fonts/packages/
mkdir $REPO/fonts/packages/

rm -rf $REPO/fonts/.fonts/
mkdir $REPO/fonts/.fonts/

#Nerd Fonts:
	log "Installing Nerd Fonts." "blue"
	echo " "
	
	version="v3.1.1"
	url="https://github.com/ryanoasis/nerd-fonts/releases/download"

	names[1]="Cascadia Cove"
	names[2]="Fantasque Sans"
	names[3]="Jet Brains"
	names[4]="Victor"

	fonts[1]="CascadiaCode"
	fonts[2]="FantasqueSansMono"
	fonts[3]="JetBrainsMono"
	fonts[4]="VictorMono"

	for index in $(seq 4); do
		log "Installing ${names[$index]} Font." "blue"
		echo " "

		wget ${url}/${version}/${fonts[$index]}.zip -P $REPO/fonts/packages/

		if [ $? -eq 0 ]; then
			mkdir $REPO/fonts/.fonts/${fonts[$index]}
			unzip $REPO/fonts/packages/${fonts[$index]}.zip -d $REPO/fonts/.fonts/${fonts[$index]}/
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
	rm -rf $HOME/.fonts/
	ln -s $REPO/fonts/.fonts/ $HOME/.fonts/

	echo " "
	log "Nerd Fonts Configured." "green"
