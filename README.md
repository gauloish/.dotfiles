# My Dotfiles

Dotfiles for Fedora and Windows.

# Installation

Guide to install dotfiles in Fedora and Windows

## Fedora

Install **Wget**:

```shell
sudo dnf install wget
```

Download the ```install.sh``` file:

```shell
wget https://github.com/gauloish/.dotfiles/raw/main/install.sh
```

Run ```install.sh``` file to install dotfiles:

```shell
sh install.sh
```

Install grub theme:

```shell
sh $HOME/.dotfiles/grub/install.sh #(1080p or ultrawide)
```

## Windows

Open a PowerShell Terminal (as administrator) and change the execution policies:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Now, open other PowerShell terminal (not as administrator) and download the ```install.ps1``` file:

```powershell
Invoke-WebRequest -Uri "https://github.com/gauloish/.dotfiles/raw/main/install.ps1" -OutFile "$HOME\install.ps1"
```

Run ```install.ps1``` file to install dotfiles:

```shell
cd $HOME; .\install.ps1
```

Enjoy and have fun.
