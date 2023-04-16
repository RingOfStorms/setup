# !/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;
            [Nn]*) return  1 ;;
        esac
    done
}

function confirm_file_del {
  FILE=$1
  if [[ -f "$FILE" ]]; then
    yes_or_no "$FILE file already exists. List contents?" && cat $FILE
    yes_or_no "Delete file so it can be replaced?" && rm -f $FILE || echo "Did not delete file."
  elif [[ -d "$FILE" ]]; then
    yes_or_no "$FILE directory already exists. List contents?" && ls -l $FILE
    yes_or_no "Delete directory so it can be replaced?" && rm -rf $FILE || echo "Did not delete directory."
  elif [[ -L "$FILE" ]]; then
    yes_or_no "$FILE link already exists. List contents?" && ls -lh $FILE
    echo yes_or_no "Delete link so it can be replaced?" && rm -f $FILE || echo "Did not delete link."
  fi
}

function link_if_ne {
  FILE=$1
  SOURCE=$2
  [ ! -f $FILE ] && [ ! -d $FILE ] && [ ! -L $FILE ] && ln -s $SOURCE $FILE && echo " >Linked $SOURCE to $FILE" || echo "| Skipped linking $SOURCE to $FILE"
}

function copy_if_ne {
  FILE=$1
  SOURCE=$2
  cp $SOURCE $FILE
  [ ! -f $FILE ] && [ ! -d $FILE ] && [ ! -L $FILE ] && cp $SOURCE $FILE && echo "> Copied $SOURCE to $FILE" || echo "| Skipped copying $SOURCE to $FILE"
}

# env
mkdir -p ~/.config/environment
touch ~/.config/environment/.env

# shell configs
touch ~/.zshenv
if ! grep -q zshenv_mine ~/.zshenv; then
  echo "adding source for my zshenv..."
  echo "source "$SCRIPT_DIR"/dotfiles/zshenv_mine" >> ~/.zshenv
  source ~/.zshenv
fi

touch ~/.zprofile
if ! grep -q zprofile_mine ~/.zprofile; then
  echo "adding source for my zprofile..."
  echo "source "$SCRIPT_DIR"/dotfiles/zprofile_mine" >> ~/.zprofile
  source ~/.zshprofile
fi

if ! grep -q zprofile_work_tl ~/.zprofile; then
  yes_or_no "Source custom zprofile work tl?" && \
    echo "source "$SCRIPT_DIR"/dotfiles/zprofile_work_tl" >> ~/.zprofile && \
    source ~/.zshprofile
fi

if ! grep -q zprofile_mine_mbp ~/.zprofile; then
  yes_or_no "Source custom zprofile mine mbp?" && \
    echo "source "$SCRIPT_DIR"/dotfiles/zprofile_mine_mbp" >> ~/.zprofile && \
    source ~/.zshprofile
fi

touch ~/.zshrc
if ! grep zshrc_mine ~/.zshrc; then
  echo "adding source for my zshrc..."
  echo "source "$SCRIPT_DIR"/dotfiles/zshrc_mine" >> ~/.zshrc
  source ~/.zshrc
fi

if ! command -v rustup &> /dev/null; then
    echo "Installing rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    rustup update stable
    rustup update nightly
fi

if ! command -v cargo-binstall &> /dev/null; then
    echo "Installing cargo binstall..."
    cargo install cargo-binstall
fi

if ! command -v rtx &> /dev/null; then
    echo "Installing rtx..."
    cargo-binstall rtx-cli
fi

if ! command -v sccache &> /dev/null; then
  echo "Installing sccache..."
  cargo-binstall sccache -y
fi

if ! command -v genemichaels &> /dev/null; then
  echo "Installing genemichaels..."
  cargo-binstall genemichaels -y
fi

#RTX_PLUGINS="neovim python age"
#for plugin in $RTX_PLUGINS; do
    #if ! rtx plugins | grep $plugin; then
        #echo "Installing $plugin rtx plugin..."
        #rtx plugin install $plugin
    #fi
#done

# postgres settings
FILE=~/.psqlrc
#confirm_file_del $FILE
link_if_ne $FILE $SCRIPT_DIR/dotfiles/psqlrc

# git
mkdir -p ~/.config/git
FILE=~/.config/git/ignore
#confirm_file_del $FILE
link_if_ne $FILE $SCRIPT_DIR/config/git/ignore

FILE=~/.config/git/config
#confirm_file_del $FILE
link_if_ne $FILE $SCRIPT_DIR/config/git/gitconfig

# Vim
# Astro Vim for now
if [[ ! -d "${HOME}/.config/nvim" ]]; then
  yes_or_no "Install AstroVim config?" && \
    git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim && \
    git clone https://github.com/RingOfStorms/astronvim_config ~/.config/nvim/lua/user
else
  echo nvim config already setup
fi

# # # # #
echo done
