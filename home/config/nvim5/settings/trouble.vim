" Trouble -- SETTINGS
lua << EOF
  require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    auto_close = true, -- automatically close the list when you have no diagnostics
    action_keys = { -- key mappings for actions in the trouble list
        -- map to {} to remove a mapping, for example:
        -- close = {},
        cancel = {}, -- cancel the preview and get back to your last window / buffer / cursor
    },
  }
EOF
nnoremap <leader>xx <cmd>TroubleToggle<cr>