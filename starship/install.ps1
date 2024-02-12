. "$HOME\.dotfiles\utils.ps1"

# Starship:
	echo "Installing Starship."

	scoop install starship

 	mklink "$REPO\starship\starship.toml" "$CONF\starchip.toml"
