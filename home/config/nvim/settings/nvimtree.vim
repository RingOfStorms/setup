" nvim-tree -- SETTINGS
noremap <C-t> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
" nnoremap <leader>n :NvimTreeOpen<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
" Start NvimTree and put the cursor back in the other window.
let g:nvim_tree_auto_open = 1
" Exit Vim if NERDTree is the only window remaining in the only tab.
let g:nvim_tree_auto_close = 1
" this variable must be enabled for colors to be applied properly
lua <<EOF
  local tree_cb = require'nvim-tree.config'.nvim_tree_callback
  -- default mappings
  vim.g.nvim_tree_bindings = {
    { key = "<Left>", cb = tree_cb("close_node") },
    { key = "h", cb = tree_cb("close_node") },
    { key = "<Right>", cb = tree_cb("open_node") },
    { key = "l", cb = tree_cb("open_node") },
  }
EOF