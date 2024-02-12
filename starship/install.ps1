. "$HOME\.dotfiles\utils.ps1"

# Starship:
	echo "Installing Starship."

	scoop install starship

	sudo New-Item -Path "$CONF\starchip.toml" -ItemType Junction -Value "$REPO\starship\starship.toml"
