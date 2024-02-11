#!/bin/sh

source $HOME/.dotfiles/utils.sh

#----- Install Grub Theme

if [ "$1" == "1080p" ] || [ "$1" == "ultrawide" ]; then
    rm -rf $REPO/grub/package/
    mkdir $REPO/grub/package/

    git -C $REPO/grub/package/ clone https://github.com/vinceliuice/grub2-themes.git
    sudo sh $REPO/grub/package/grub2-themes/install.sh --remove stylish
    sudo sh $REPO/grub/package/grub2-themes/install.sh --theme stylish --icon white --screen $1

    rm -rf $REPO/grub/package/
fi
