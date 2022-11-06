#!/bin/bash

# https://stackoverflow.com/a/246128
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FILES=".tmux.conf
.vimrc
.zshrc
.Xmodmap"

# TODO: Install all required tools here instead of checking every time. (apt-get will just ignore anything that is already installed)
sudo apt-get -y install curl vim vim-nox tmux mono-devel build-essential cmake vim python3-dev golang npm nodejs jq

for f in $FILES
do
	if [ -L "$HOME/$f" ]; then
		echo "$f: symlink already exists in home dir"
	else
		echo "$f: symlink does not currently exist. Creating symlink..."

		if [ -f "$HOME/$f" ]; then
			echo "$f: file exits: symlink was not created"
		else
			ln -s $DIR/$f "$HOME/$f"
     
      # Vim Setup 
      if [ "$f" == ".vimrc" ]; then
        echo "$f: Cloning Vundle..."
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

        echo "$f: Downloading and Installing Pathogen...."
        mkdir -p ~/.vim/autoload ~/.vim/bundle && \
        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim 

        echo "$f: Installing Plugins..."
	
        vim +PluginInstall +qall

        python3 ~/vim/bundle/YouCompleteMe/install.py --all
      fi
		fi
	fi
done

# Set up zsh

if ! [ -x "$(command -v zsh)" ]; then
  echo "Install zsh and set as default shell..."
  sudo apt-get install zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --keep-zshrc
fi

# Oh My ZSH Extensions

# Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
