# My Dotfiles

Dotfiles for Linux Fedora.

# Installation

> **_NOTE:_** The installation assumes that you are in ```~/``` directory.

Install **Git**:

```shell
sudo dnf install git
```

And install **Git Credential Manager**:

```shell
curl -L https://aka.ms/gcm/linux-install-source.sh | sh
git-credential-manager configure
```