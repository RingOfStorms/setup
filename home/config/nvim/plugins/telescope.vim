" Telescope -- SETTINGS
" files using Telescope command-line sugar.
" nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>ff :lua require('telescope').extensions.fzf_writer.files()<cr>
" nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fg :lua require('telescope').extensions.fzf_writer.staged_grep()<cr>
" nnoremap <leader>fb <cmd>Telescope buffers<cr>
" nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" fzf in Telescope
lua << EOF
  require('telescope').setup {
     extensions = {
          fzf = {
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
          },
          fzf_writer = {
              minimum_grep_characters = 2,
              minimum_files_characters = 2,
              -- use_highlighter = true,
          }
      },
    file_ignore_patterns = {"%.git", "node%_modules"}
  }
EOF
