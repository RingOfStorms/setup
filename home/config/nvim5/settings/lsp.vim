" LSP -- SETTINGS
nnoremap gd :lua vim.lsp.buf.definition()<cr>
nnoremap gr :LspTrouble lsp_references<cr>
lua << EOF
  --local utils = require("gb.utils")
  local nvim_lsp = require("lspconfig")
  --keymap = utils.map
  --opt = utils.opt

  local function custom_on_init()
    print("Language Server Protocol started!")
  end

  local function custom_root_dir()
    if (string.find(vim.fn.expand("%f"), "node_modules/") == nil) then
      return nvim_lsp.util.root_pattern(".git")
    end

    return nil
  end

  nvim_lsp.vimls.setup {}

  --must have run: npm install -g typescript && npm i -g typescript-language-server
  nvim_lsp.tsserver.setup {
    -- This makes sure tsserver is not used for formatting
    -- on_attach = nvim_lsp.tsserver_on_attach,
    on_attach = function(client)
      if client.config.flags then
        client.config.flags.allow_incremental_sync = true
      end
      client.resolved_capabilities.document_formatting = false
      require "lsp_signature".on_attach()
    end,
    root_dir = nvim_lsp.util.root_pattern("tsconfig.json", ".git"),
    settings = {documentFormatting = false},
    on_init = custom_on_init
  }

  nvim_lsp.rust_analyzer.setup {}

  --must run: npm install -g pyright
  nvim_lsp.pyright.setup {
    on_init = custom_on_init,
    on_attach = function(client)
      require "lsp_signature".on_attach()
    end
  }

  vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      virtual_text = true,
      signs = true,
      update_in_insert = true
    }
  )

  -- npm i -g vscode-langservers-extracted
  nvim_lsp.cssls.setup {
    on_init = custom_on_init
  }

  -- npm i -g vscode-langservers-extracted
  nvim_lsp.html.setup {
    on_init = custom_on_init
  }

  local eslint_d = {
    lintCommand = "eslint_d --stdin --fix-to-stdout --stdin-filename ${INPUT}",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
    formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename ${INPUT}",
    formatStdin = true
  }

  local rustExe = "rustfmt"
  local rustArgs = "--emit=stdout"
  local rustStdin = true

  local rustfmt = {
    formatCommand = rustExe .. rustArgs .. "${INPUT}",
    formatStdin = rustStdin
  }

  local prettierArgs = {"--stdin", "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"}

  local prettier = {
    formatCommand = "./node_modules/.bin/prettier" .. table.concat(prettierArgs, " "),
    formatStdin = true
  }

  local languages = {
    typescript = {prettier, eslint_d},
    javascript = {prettier, eslint_d},
    typescriptreact = {prettier, eslint_d},
    ["typescript.tsx"] = {prettier, eslint_d},
    javascriptreact = {prettier, eslint_d},
    ["javascript.jsx"] = {prettier, eslint_d},
    yaml = {prettier},
    json = {prettier},
    html = {prettier},
    scss = {prettier},
    css = {prettier},
    markdown = {prettier},
    rust = {rustfmt},
    python = {
      {
        formatCommand = "black",
        formatStdin = true
      },
      {
        formatCommand = "isort",
        formatStdin = true
      }
    }
  }

  nvim_lsp.efm.setup {
    init_options = {documentFormatting = true},
    filetypes = vim.tbl_keys(languages),
    root_dir = custom_root_dir(),
    settings = {
      languages = languages
    }
  }

  require "compe".setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = "enable",
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,
    source = {
      path = {kind = "   (Path)"},
      buffer = {kind = "   (Buffer)"},
      calc = {kind = "   (Calc)"},
      nvim_lsp = {kind = "   (LSP)"},
      nvim_lua = false,
      spell = {kind = "   (Spell)"},
      tags = false,
      vim_dadbod_completion = false,
      snippets_nvim = false,
      ultisnips = false,
      treesitter = false,
      emoji = {kind = " ﲃ  (Emoji)", filetypes = {"markdown", "text"}}
      -- for emoji press : (idk if that in compe tho)
    }
  }

  vim.fn.sign_define("LspDiagnosticsSignError", {text = "▊"})
  vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "▊"})
  vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "▊"})
  vim.fn.sign_define("LspDiagnosticsSignHint", {text = "▊"})

  require("lspkind").init(
    {
      with_text = true,
      symbol_map = {
        Text = "  ",
        Method = "  ",
        Function = "  ",
        Constructor = "  ",
        Variable = "[]",
        Class = "  ",
        Interface = " 蘒",
        Module = "  ",
        Property = "  ",
        Unit = " 塞 ",
        Value = "  ",
        Enum = " 練",
        Keyword = "  ",
        Snippet = "  ",
        Color = "",
        File = "",
        Folder = " ﱮ ",
        EnumMember = "  ",
        Constant = "  ",
        Struct = "  "
      }
    }
  )

  vim.g.completion_matching_strategy_list = {"exact", "substring", "fuzzy"}
  --opt("o", "completeopt", "menu,menuone,noselect")

  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local check_back_space = function()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
      return true
    else
      return false
    end
  end

  -- Use (s-)tab to:
  --- move to prev/next item in completion menuone
  _G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t "<C-n>"
    elseif check_back_space() then
      return t "<Tab>"
    else
      return vim.fn["compe#complete"]()
    end
  end
  _G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t "<C-p>"
    else
      return t "<BS>"
    end
  end

  vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
  --keymap("i", "<C-Space>", "compe#complete()", {silent = true, expr = true})
  --keymap("i", "<CR>", 'compe#confirm("<CR>")', {silent = true, expr = true})

  --keymap("n", "gd", "lua vim.lsp.buf.definition()", {silent = true, cmd_cr = true})
  --keymap("n", "gR", "lua vim.lsp.buf.rename()", {cmd_cr = true})
  --keymap("n", "gr", "LspTrouble lsp_references", {cmd_cr = true})
  --keymap("n", "<leader>e", "lua vim.lsp.diagnostic.goto_next()", {silent = true, cmd_cr = true})
  --keymap("n", "<leader>cd", "lua vim.lsp.diagnostic.show_line_diagnostics()", {silent = true, cmd_cr = true})
   --keymap("n", "K", "lua vim.lsp.buf.hover()", {silent = true, cmd_cr = true})
EOF