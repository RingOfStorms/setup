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
  if yes_or_no "? Source custom zshenv mine joeb?"; then
    echo ". "$SCRIPT_DIR"/dotfiles/zshenv_mine_joeb" >> ~/.zshenv 
  else
    echo "# DISABLED # . "$SCRIPT_DIR"/dotfiles/zshenv_mine_joeb" >> ~/.zshenv 
  fi
}

touch ~/.zprofile
grep -q zprofile_mine_all ~/.zprofile || { 
  echo "> adding source for my zprofile all..." && \
  echo ". "$SCRIPT_DIR"/dotfiles/zprofile_mine_all" >> ~/.zprofile 
}

grep -q zprofile_work_tl ~/.zprofile || {
  if yes_or_no "? Source custom zprofile work tl?"; then
    echo ". "$SCRIPT_DIR"/dotfiles/zprofile_work_tl" >> ~/.zprofile 
  else
    echo "# DISABLED # . "$SCRIPT_DIR"/dotfiles/zprofile_work_tl" >> ~/.zprofile 
  fi
}

grep -q zprofile_mine_mbp ~/.zprofile || {
  if yes_or_no "? Source custom zprofile mine mbp?"; then
    echo ". "$SCRIPT_DIR"/dotfiles/zprofile_mine_mbp" >> ~/.zprofile 
  else
    echo "# DISABLED # . "$SCRIPT_DIR"/dotfiles/zprofile_mine_mbp" >> ~/.zprofile 
  fi
}

grep -q zprofile_mine_joeb ~/.zprofile || {
  if yes_or_no "? Source custom zprofile mine joeb?"; then
    echo ". "$SCRIPT_DIR"/dotfiles/zprofile_mine_joeb" >> ~/.zprofile 
  else
    echo "# DISABLED # . "$SCRIPT_DIR"/dotfiles/zprofile_mine_joeb" >> ~/.zprofile 
  fi
}

touch ~/.zshrc
grep -q zshrc_mine_all ~/.zshrc || { 
  echo "> adding source for my zshrc..." && \
  echo ". "$SCRIPT_DIR"/dotfiles/zshrc_mine_all" >> ~/.zshrc 
}

grep -q zshrc_mine_joeb ~/.zshrc || {
  if yes_or_no "? Source custom zshrc mine joeb?"; then
    echo ". "$SCRIPT_DIR"/dotfiles/zshrc_mine_joeb" >> ~/.zshrc 
  else
    echo "# DISABLED # . "$SCRIPT_DIR"/dotfiles/zshrc_mine_joeb" >> ~/.zshrc 
  fi
}

# TODO this install script sucks and doesn't actually work on first run, needs to be run multiple times since things later in this script require bits from above...
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

command -v mise >/dev/null 2>&1 || {
    echo "> Installing mise..." && \
    curl https://mise.jdx.dev/install.sh | sh
}

command -v sccache >/dev/null 2>&1 || {
  echo "> Installing sccache..." && \
  cargo-binstall sccache -y
}

command -v genemichaels >/dev/null 2>&1 || {
  echo "> Installing genemichaels..." && \
  cargo-binstall genemichaels -y
}

# TODO install tmux

#MISE_PLUGINS="neovim python age"
#for plugin in $MISE_PLUGINS; do
    #if [ ! mise plugins | grep $plugin ]; then
        #echo "Installing $plugin mise plugin..."
        #mise plugin install $plugin
    #fi
#done

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "MacOS specifics..."
  
  mkdir -p ~/.hammerspoon
  FILE=~/.hammerspoon/init.lua
  link_if_ne $FILE $SCRIPT_DIR/config/hammerspoon/init.lua

  FILE=~/.hammerspoon/AwesomeWM.lua
  link_if_ne $FILE $SCRIPT_DIR/config/hammerspoon/AwesomeWM.lua

  FILE=~/.hammerspoon/Util.lua
  link_if_ne $FILE $SCRIPT_DIR/config/hammerspoon/Util.lua

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

# tmux
mkdir -p ~/.config/tmux
FILE=~/.config/tmux/tmux.reset.conf
link_if_ne $FILE $SCRIPT_DIR/config/tmux/tmux.reset.conf
FILE=~/.config/tmux/tmux.conf
link_if_ne $FILE $SCRIPT_DIR/config/tmux/tmux.conf

# starship
mkdir -p ~/.config
FILE=~/.config/starship.toml
link_if_ne $FILE $SCRIPT_DIR/config/starship.toml

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
