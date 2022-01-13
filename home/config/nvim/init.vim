" Main entry point for Neovim and Vim (This file will work as vimrc file)
" Link this file
"   mkdir -p ~/.config/nvim && ln -s ~/setup/home/config/nvim/init.vim ~/.config/nvim/init.vim && ln -s ~/setup/home/config/nvim/init.vim ~/.vimrc
" Author: Josua Bell
"

let $SETUP = '$HOME/setup/home/config/nvim'

source $SETUP/0_basic_vim_settings.vim
source $SETUP/1_plugin_installation.vim
