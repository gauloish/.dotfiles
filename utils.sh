#!/bin/sh

REPO=$HOME/.dotfiles
CONF=$HOME/.config

log() {
	declare -A colors

	colors["black"]="\033[30m"
	colors["red"]="\033[31m"
	colors["green"]="\033[32m"
	colors["yellow"]="\033[33m"
	colors["blue"]="\033[34m"
	colors["magenta"]="\033[35m"
	colors["cyan"]="\033[36m"
	colors["white"]="\033[37m"
	colors["default"]="\033[39m"

	colors["end"]="\033[0m"

	echo -e "${colors[$2]}$1${colors["end"]}"
}
