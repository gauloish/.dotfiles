#!/bin/sh

log() {
	declare -A colors

	colors["red"]="\033[31;1m"
	colors["yellow"]="\033[33;1m"
	colors["green"]="\033[32;1m"
	colors["blue"]="\033[34;1m"
	colors["end"]="\033[0m"

	echo -e "${colors[$2]} $1 ${colors["end"]}"
}
