" Auto install vim-plug
"   https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Installing plugins
"   https://github.com/junegunn/vim-plug/wiki/tutorial#installing-plugins
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
  Plug 'ciaranm/detectindent'
  Plug 'itchyny/lightline.vim'


  " nvim only plugins
  if has('nvim')
    Plug 'nvim-lua/plenary.nvim'

    Plug 'nvim-lua/popup.nvim'

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'nvim-telescope/telescope-fzf-writer.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    Plug 'kyazdani42/nvim-web-devicons' " for file icons
    Plug 'kyazdani42/nvim-tree.lua'
  endif
call plug#end()

nnoremap <leader>pl :PlugInstall<CR>

let $PLUGIN = '$HOME/setup/home/config/nvim/plugins'

"source $PLUGIN/de
" nvim only plugins
if has('nvim')
  source $PLUGIN/telescope.vim

  source $PLUGIN/nvimtree.vim
endif
