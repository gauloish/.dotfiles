. "$HOME\.dotfiles\utils.ps1"

# Starship:
	echo "Installing Starship."

	scoop install starship

	rm -Force "$CONF\starship.toml"
	sudo ln -s "$REPO\starship\starship.toml" "$CONF\starship.toml"
