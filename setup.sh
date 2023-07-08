#!/bin/bash

# https://stackoverflow.com/a/246128
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# List of files in root directory to be symlinked in home dir.
FILES=(
  .tmux.conf
  .vimrc
  .zshrc
  .Xmodmap
  .alias
  .function
  .gitconfig
)

# List of dependent libs that should be installed with apt-get
UTILS=(
  curl
  fzf
  vim
  vim-nox
  tmux
  mono-devel
  build-essential
  cmake
  vim
  python3-dev
  python3-pip
  golang
  npm
  nodejs
  jq
  net-tools
  nvim
)

echo "##################################"
echo "###### Install Dependencies ######"
echo "##################################"

utilsToInstall=()
utilsInstalled=()

for u in ${UTILS[@]};
do
  dpkg --status $u &> /dev/null
  if [ $? -eq 1 ]; then
    echo "Install $u"
    utilsToInstall+=("${u}")
  else
    utilsInstalled+=("${u}")
  fi
done

if [ ${#utilsToInstall[@]} -eq 0 ]; then
  echo "[SKIPPED] No dependencies to be installed"
else
  echo "Installing Dependencies via apt-get: ${utilsToInstall[*]}"
  sudo apt-get -y install ${utilsToInstall[*]} 
fi

# Install Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# TODO: Install all required tools here instead of checking every time. (apt-get will just ignore anything that is already installed)

echo "############################"
echo "##### Set up Dot Files #####"
echo "############################"
sleep 1

for f in ${FILES[@]};
do
    if [ -L "$HOME/$f" ]; then
        echo "[SKIPPED] Symlink for $f already exists in home dir"
    else
        echo "$f: symlink does not currently exist. Creating symlink..."

        if [ -f "$HOME/$f" ]; then
            echo "[SKIPPED] $f already exits: symlink was not created"
        else
            ln -s $DIR/$f "$HOME/$f"
        fi
    fi
done

echo "##################"
echo "##### NeoVim #####"
echo "##################"

if [ ! -d "$HOME/.config/nvim" ]; then
    ln -s $DIR/nvim-config $HOME/.config/nvim
    
    nvim +PackerSync +qall
fi

# Set up zsh
echo "#####################"
echo "##### ZSH Setup #####"
echo "#####################"

sleep 1

if [ ! -d ~/.oh-my-zsh ]; then
  echo "Setting up Oh My Zsh."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --keep-zshrc
else
  echo "[SKIPPED] Oh My ZSH Already Installed"
fi

# Oh My ZSH Extensions

# Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
