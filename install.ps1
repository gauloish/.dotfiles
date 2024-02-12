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

	scoop install ln
 	scoop install touch
  	scoop install time
	scoop install sudo
	scoop install zip
	scoop install unzip
	scoop install wget
	scoop install curl
	scoop install git

# Setting Git:
	rm -Force .gitconfig
	
	# Git Init
	git config --global init.defaultBranch main

	# Git User
	git config --global user.email temp
	git config --global user.name temp

# Git Credential Manager:
	echo "Installing Git Credential Manager."
	
	scoop bucket add extras

	scoop install extras/git-credential-manager

# Create Dotfiles Directory:
	rm -Force $REPO
	mkdir .dotfiles
	cd .dotfiles

# Initialize Git Repository:
	git init
 	git pull $URL
 	git remote add origin $URL

# Running Setup:
   	.\setup.ps1
