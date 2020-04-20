#!/bin/bash

# https://stackoverflow.com/a/246128
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FILES=".tmux.conf
.vimrc"

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
	
      	if ! [ -x "$(command -v vim)" ]; then
	      	echo "$f: Installing Vim..."
	      	sudo apt-get install vim
      	fi

        vim +PluginInstall +qall
      fi

      # tmux setup
      if [ "$f" == ".tmux.conf" ]; then
        if ! [ -x "$(command -v tmux)" ]; then
          echo "Installing tmux..."
          sudo apt-get install tmux
        fi
      fi
		fi
	fi
done