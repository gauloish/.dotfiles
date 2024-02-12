. "$HOME\.dotfiles\utils.ps1"

# Gcc:
	echo "Installing C/C++ Dependencies."

	scoop install gcc
	scoop install make
	scoop install cmake

# Python:
	echo "Installing Python Dependencies."

	scoop install python
	curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py; python get-pip.py
	pip install pynvim
	pip install yarp

# Node:
	echo "Installing Node Dependencies."

	scoop install nodejs

# Rust:
	echo "Installing Rust Dependencies."

	scoop install rust

# Lua:
	echo "Installing Lua Dependencies."

	scoop install lua
	scoop install luarocks

# Utilitary:
	echo "Installing Utilitary."

	scoop install grep
	scoop install ripgrep
	scoop install fd

# Neovim:
	echo "Installing Neovim."

	scoop install neovim
 
#----- Configure Neovim
	echo "Configuring Neovim."
 
	rm -Force "$HOME\AppData\Local\nvim"
 	rm -Force "$HOME\AppData\Local\nvim-data"

# Nv Chad:
	echo "Installing Nv Chad Configuration"

	git clone https://github.com/NvChad/NvChad $ENV:USERPROFILE\AppData\Local\nvim --depth 1

# Link:
	rm -Force "$HOME\AppData\Local\nvim\lua\custom"
	sudo ln -s "$REPO\neovim\custom" "$HOME\AppData\Local\nvim\lua\custom"
