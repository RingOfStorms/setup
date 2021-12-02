" FIRST TIME BOOT
"   :PlugInstall
"   :TSInstall all
" UPDATES
"   :PlugUpdate
"   :TSUpdate all

" Is Apple_Terminal
let isAppleTerminal = $TERM_PROGRAM == "Apple_Terminal"

source ~/.vimrc

" vim-plug auto installation: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" vim-plug section: https://github.com/junegunn/vim-plug#example
call plug#begin(stdpath('data') . '/plugged')
Plug 'ciaranm/detectindent'
Plug 'itchyny/lightline.vim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'marko-cerovac/material.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'hrsh7th/nvim-compe'
Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind-nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'voldikss/vim-floaterm'
Plug 'folke/trouble.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'nvim-telescope/telescope-fzf-writer.nvim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
call plug#end()

source ~/.config/nvim/settings/material.vim
source ~/.config/nvim/settings/colorizer.vim
source ~/.config/nvim/settings/detectindent.vim
source ~/.config/nvim/settings/nvimtree.vim
source ~/.config/nvim/settings/telescope.vim
source ~/.config/nvim/settings/compe.vim
source ~/.config/nvim/settings/floatingterminal.vim
source ~/.config/nvim/settings/trouble.vim
source ~/.config/nvim/settings/lsp.vim
