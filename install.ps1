$REPO = "$HOME\.dotfiles"
$CONF = "$HOME\.config"

$URL = "https://github.com/gauloish/.dotfiles"

# Stay Home:
	cd $HOME

# ----- Install Scoop
	echo "Installing Scoop."

	Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
	Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# ----- Install Dependencies

# Utilities (Zip, Unzip, Wget, Curl and Git):
	echo "Installing Utilities (Zip, Unzip, Wget, Curl and Git)."

	scoop bucket add main

	scoop install main/zip
	scoop install main/unzip
	scoop install main/wget
	scoop install main/curl
	scoop install main/git

# Setting Git:
	rm -Force .gitconfig
	
	# Git Init
	git config --global init.defaultBranch main

	# Git User
	git config --global user.email 125079293+gauloish@users.noreply.github.com
	git config --global user.name gauloish

	# Git Credential
	git config --global credential.helper manager
	git config --global credential.credentialStore cache
	git config --global credential.cacheOptions --timeout 3600

	# Git Core
	git config --global core.editor nvim

# Git Credential Manager:
	echo "Installing Git Credential Manager."
	
	scoop bucket add extras

	scoop install extras/git-credential-manager

# Nerd Fonts:
	echo "Installing Git Credential Manager."
	
	scoop bucket add nerd-fonts

	scoop install nerd-fonts/Cascadia-Code
	scoop install nerd-fonts/FantasqueSansMono-NF
	scoop install nerd-fonts/JetBrains-Mono
	scoop install nerd-fonts/Victor-Mono

# Gcc:
	scoop install main/gcc

# Python:
	scoop install main/python
	curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py; python get-pip.py
	pip install pynvim
	pip install yarp

# Node:
	scoop install main/nodejs

# Rust:
	scoop install main/rust

# Lua:
	scoop install main/lua
	scoop install main/luarocks

# Utilitary:
	scoop install main/grep
	scoop install main/ripgrep
	scoop install main/fd

# Starship:
	scoop install main/starship

# Create Dotfiles Directory:
	#rm -Force $REPO
	#mkdir .dotfiles
	#cd .dotfiles

# Initialize Git Repository:
	#git init
 	#git pull $URL
 	#git remote add origin $URL

# Running Setup:
   	#sh $REPO/setup.sh
