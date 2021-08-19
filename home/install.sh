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
  [ ! -f $FILE ] && [ ! -d $FILE ] && [ ! -L $FILE ] && ln -s $SOURCE $FILE && echo " > Linked $SOURCE to $FILE" || echo " | Skipped linking $SOURCE to $FILE"
}

function load_nvm {
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
}

# git ignore
echo
mkdir -p ~/.config/git
FILE=~/.config/git/ignore
confirm_file_del $FILE
link_if_ne $FILE $SCRIPT_DIR/config/git/ignore

# vim
echo
mkdir -p ~/.config/.vim/undodir
FILE=~/.vimrc
confirm_file_del $FILE
link_if_ne $FILE $SCRIPT_DIR/.vimrc

# git
echo
FILE=~/.gitconfig
confirm_file_del $FILE
link_if_ne $FILE $SCRIPT_DIR/.gitconfig

# nvim requirements
if ! (echo -n "nvim\t" && nvim --version) ; then echo "Install nvim..." && (brew --version &> /dev/null && brew install nvim || sudo snap install --beta nvim --classic) fi
if ! (echo -n "fzf\t" && fzf --version) ; then echo "Installing fzf..." && (brew --version &> /dev/null && brew install fzf || sudo apt install fzf) fi
if ! (echo -n "rg\t" && rg --version) ; then echo "Installing rg..." && (brew --version &> /dev/null && brew install rg || sudo apt install ripgrep) fi
if ! (echo -n "curl\t" && curl --version) ; then echo "Installing curl..." && (brew --version &> /dev/null && brew install curl || sudo apt install curl) fi
if ! (load_nvm && nvm --version &> /dev/null); then
  echo "installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
  load_nvm
  nvm install --lts
fi
if ! (echo -n "pyright\t" && npm list -g pyright) ; then echo "Installing pyright..." && npm install -g pyright ;fi
if ! (echo -n "typescript\t" && npm list -g typescript) ; then echo "Installing typescript..." && npm install -g typescript ;fi
if ! (echo -n "typescript-language-server\t" && npm list -g typescript-language-server) ; then echo "Installing typescript-language-server..." && npm install -g typescript-language-server ;fi


# nvim settings
mkdir -p ~/.config/nvim
FILE=~/.config/nvim/init.vim
confirm_file_del $FILE
link_if_ne $FILE $SCRIPT_DIR/config/nvim/init.vim
FILE=~/.config/nvim/settings
confirm_file_del $FILE
link_if_ne $FILE $SCRIPT_DIR/config/nvim/settings

nvim --headless +PlugInstall +qall
nvim --headless +TSInstall +qall

echo done