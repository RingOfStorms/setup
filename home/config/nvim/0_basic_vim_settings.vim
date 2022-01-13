" set leader character to space
let mapleader = " "
" show line numbers
set number
" enable setting title
set title
" set default shell to zsh, -l is for profile -i is for rc (https://stackoverflow.com/a/9092644/4505547)
set shell=zsh\ -li

" reload vimrc
nnoremap <leader>sv :source $MYVIMRC<CR>

" Keybindings for split screen to move between screens with ctrl
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k

" screen width increase decrease
noremap <leader>> :10winc ><cr>
noremap <leader>< :10winc <<cr>

" bracket forward and backward
noremap <C-[> <C-o>
noremap <C-]> <C-I>

" leader shortcuts
nnoremap <leader><leader> :w<cr>
nnoremap <leader>wq :wq<cr>
nnoremap <leader>qq :qa!<cr>
nnoremap <leader><leader>q :q<cr>

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    silent !mkdir ~/.config/.vim_undo > /dev/null 2>&1
    set undodir=~/.config/.vim_undo
    set undofile
    set undolevels=1001
endif

" Tab default to 2 spaces
set tabstop=2
set softtabstop=-1
set shiftwidth=0
set expandtab
set autoindent
" filetype plugin indent on
" Custom filetype example. File types: :echo getcompletion('', 'filetype')
" autocmd Filetype html setlocal tabstop=2 shiftwidth=2 softtabstop=0 expandtab

" Diff buffer to original file
"   https://vim.fandom.com/wiki/Diff_current_buffer_and_the_original_file
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()
nnoremap <leader>ds :DiffSaved<cr>
