#!/bin/sh

source $HOME/.dotfiles/utils.sh

if [ "$1" == "Grey" ] || [ "$1" == "Dracula" ] || [ "$1" == "Nord" ]; then
    if [ ! -d "$CONF/gtk-4.0/" ]; then
        mkdir $CONF/gtk-4.0
    fi

    rm -rf $CONF/gtk-4.0/assets
    rm -rf $CONF/gtk-4.0/gtk.css
    rm -rf $CONF/gtk-4.0/gtk-dark.css

    theme=Orchis-Grey-Dark

    if [ "$1" == "Dracula" ] || [ "$1" == "Nord" ]; then
    theme=$theme-$1
    fi

    ln -s $HOME/.themes/$theme/gtk-4.0/assets $CONF/gtk-4.0/assets
    ln -s $HOME/.themes/$theme/gtk-4.0/gtk.css $CONF/gtk-4.0/gtk.css
    ln -s $HOME/.themes/$theme/gtk-4.0/gtk-dark.css $CONF/gtk-4.0/gtk-dark.css
else
    log "Invalid Theme!!!" "red"
fi
