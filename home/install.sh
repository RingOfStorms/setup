#!/usr/bin/env bash 

SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

yes_or_no() {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;
            [Nn]*) return  1 ;;
        esac
    done
}

link_if_ne() {
  FILE=$1
  SOURCE=$2
  [ ! -f $FILE ] && [ ! -d $FILE ] && [ ! -L $FILE ] && ln -s $SOURCE $FILE && echo "> Linked $SOURCE to $FILE" || echo "| Skipped linking $SOURCE to $FILE"
}

copy_if_ne() {
  FILE=$1
  SOURCE=$2
  [ ! -f $FILE ] && [ ! -d $FILE ] && [ ! -L $FILE ] && cp $SOURCE $FILE && echo "> Copied $SOURCE to $FILE" || echo "| Skipped copying $SOURCE to $FILE"
}

# env
mkdir -p ~/.config/environment
touch ~/.config/environment/.env

# shell configs
touch ~/.zshenv
grep -q zshenv_mine_all ~/.zshenv || {
  echo "> adding source for my zshenv..." && \
  echo ". "$SCRIPT_DIR"/dotfiles/zshenv_mine_all" >> ~/.zshenv 
}

touch ~/.zshenv
grep -q zshenv_mine_joeb ~/.zshenv || {
  yes_or_no "? Source custom zshenv mine joeb?" && \
  echo ". "$SCRIPT_DIR"/dotfiles/zshenv_mine_joeb" >> ~/.zshenv 
}

touch ~/.zprofile
grep -q zprofile_mine_all ~/.zprofile || { 
  echo "> adding source for my zprofile all..." && \
  echo ". "$SCRIPT_DIR"/dotfiles/zprofile_mine_all" >> ~/.zprofile 
}

grep -q zprofile_work_tl ~/.zprofile || {
  yes_or_no "? Source custom zprofile work tl?" && \
    echo ". "$SCRIPT_DIR"/dotfiles/zprofile_work_tl" >> ~/.zprofile 
}

grep -q zprofile_mine_mbp ~/.zprofile || {
  yes_or_no "? Source custom zprofile mine mbp?" && \
    echo ". "$SCRIPT_DIR"/dotfiles/zprofile_mine_mbp" >> ~/.zprofile 
}

grep -q zprofile_mine_joeb ~/.zprofile || {
  yes_or_no "? Source custom zprofile mine joeb?" && \
    echo ". "$SCRIPT_DIR"/dotfiles/zprofile_mine_joeb" >> ~/.zprofile 
}

touch ~/.zshrc
grep -q zshrc_mine_all ~/.zshrc || { 
  echo "> adding source for my zshrc..." && \
  echo ". "$SCRIPT_DIR"/dotfiles/zshrc_mine_all" >> ~/.zshrc 
}

grep -q zshrc_mine_joeb ~/.zshrc || {
  yes_or_no "? Source custom zshrc mine joeb?" && \
    echo ". "$SCRIPT_DIR"/dotfiles/zshrc_mine_joeb" >> ~/.zshrc 
}

# . "$HOME/.zshenv"
# . "$HOME/.zprofile"
# . "$HOME/.zshrc"

command -v rustup >/dev/null 2>&1 || {
    echo "> Installing rust..." && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh && \
    rustup update stable && \
    rustup update nightly
}

command -v cargo-binstall >/dev/null 2>&1 || {
    echo "> Installing cargo binstall..." && \
    cargo install cargo-binstall
}

command -v rtx >/dev/null 2>&1 || {
    echo "> Installing rtx..." && \
    cargo-binstall rtx-cli -y
}

command -v sccache >/dev/null 2>&1 || {
  echo "> Installing sccache..." && \
  cargo-binstall sccache -y
}

command -v genemichaels >/dev/null 2>&1 || {
  echo "> Installing genemichaels..." && \
  cargo-binstall genemichaels -y
}

#RTX_PLUGINS="neovim python age"
#for plugin in $RTX_PLUGINS; do
    #if [ ! rtx plugins | grep $plugin ]; then
        #echo "Installing $plugin rtx plugin..."
        #rtx plugin install $plugin
    #fi
#done

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "MacOS specifics..."
  
  mkdir -p ~/.hammerspoon
  FILE=~/.hammerspoon/init.lua
  link_if_ne $FILE $SCRIPT_DIR/dotfiles/hammerspoon.lua

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "Linux specifics..."

  # awesome
  FILE=~/.config/awesome/rc.lua
  link_if_ne $FILE $SCRIPT_DIR/config/awesome/rc.lua
else
  echo "Unknown OS!"
fi

# wezterm
FILE=~/.wezterm.lua
link_if_ne $FILE $SCRIPT_DIR/dotfiles/wezterm.lua

# postgres settings
FILE=~/.psqlrc
link_if_ne $FILE $SCRIPT_DIR/dotfiles/psqlrc

# git
mkdir -p ~/.config/git
# note that git ignore cannot be symlinked, just copy content
cp $SCRIPT_DIR/config/git/ignore ~/.config/git/ignore
echo "> Copied git ignore file to ~/.config/git/ignore"

FILE=~/.config/git/config
link_if_ne $FILE $SCRIPT_DIR/config/git/gitconfig

# Vim
# Astro Vim for now
if ! [ -d "${HOME}/.config/nvim" ]; then
  yes_or_no "Install AstroVim config?" && \
    git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim && \
    git clone https://github.com/RingOfStorms/astronvim_config ~/.config/nvim/lua/user
else
  echo "| Skipped nvim config setup, already content at ~/.config/nvim"
fi

echo "+ DONE +"
