-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- pyenv virtualenv with neovim package installed
vim.g.python3_host_prog = "~/.pyenv/versions/.neovenv-3.11.5/bin/python3"

-- This must come before the `plugins` file is loaded, so that the leader key
-- is set before lazy.nvim is loaded
-- Set leader key to <space>
vim.g.mapleader = " "
-- UltiSnips
vim.g.UltiSnipsSnippetDirectories = { "UltiSnips", "custom_snippets" }
vim.g.floatterm_fzf_layout = { window = { width = 0.6, height = 0.6, border = "sharp", highlight = "FloatermBorder" } }

-- Some sensible defaults
vim.o.backup = false
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.errorbells = false
vim.o.expandtab = true
vim.o.hidden = true
vim.o.incsearch = true
vim.o.shiftwidth = 2
vim.o.showmode = false
vim.o.smartcase = true
vim.o.softtabstop = 2
vim.o.syntax = "on"
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.undodir = vim.fn.stdpath("config") .. "/undodir"
vim.o.undofile = true
vim.o.updatetime = 350
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.bo.swapfile = false
vim.wo.number = true
vim.wo.signcolumn = "yes"
vim.wo.wrap = false
vim.opt.colorcolumn = "80,120"
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
-- set popup height
vim.opt.pumheight = 15
--
-- Completely disable editorconfig integration, as the max_line_length field
-- sets `textwidth` which is never what I want
vim.g.editorconfig = false
-- trigger snippet expansion
vim.g.UltiSnipsExpandTrigger = "<c-e>"
-- shortcut to go to next position
vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
-- shortcut to go to previous position
vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
vim.keymap.set("n", "<leader>u", ":call UltiSnips#RefreshSnippets()<CR>")

require("plugins")

-- Set custom colours for colourscheme
require("onedarkpro").setup({
  colors = { bg = "#1c1e24" },
  highlights = {
    ["@variable"] = { fg = "#dddddd" },
    ["@variable.builtin.python"] = { fg = "#ff0000" },
    ["@variable.member.python"] = { fg = "#dddddd" },
    ["@variable.member.tsx"] = { fg = "#dddddd" },
    ["@variable.parameter.python"] = { fg = "#dddddd" },
    ["@lsp.type.variable.python"] = {},
    ["@lsp.type.variable.typescriptreact"] = {},
    ["@lsp.type.class.python"] = {},
    ["@lsp.type.method.python"] = {},
    ["@lsp.type.function.python"] = {},
    ["@lsp.type.function.typescriptreact"] = {},
    ["@lsp.type.property.typescriptreact"] = {},
    ["@lsp.type.namespace.python"] = {},
    ["@lsp.typemod.variable.readonly.typescriptreact"] = {},
    ["@type.python"] = { fg = "#618b82" },
    ["@type.tsx"] = { fg = "#618b82" },
    ["@string"] = { fg = "#e5c07b" },
    ["@function"] = { fg = "#A6E22E" },
    ["@function.builtin"] = { fg = "#4DF6E8" },
    ["@function.method.call"] = { fg = "#A6E22E" },
    ["@function.method"] = { fg = "#A6E22E" },
    ["@constructor.python"] = { fg = "#A6E22E" },
    ["@function.call.tsx"] = { fg = "#A6E22E" },
    ["@constant"] = { fg = "#bb70d2" },
    ["@constant.tsx"] = { fg = "#bb70d2" },
    ["@odp.import_module.python"] = {},
    ["@odp.interpolation.python"] = { fg = "#d19f43" },
    ["@punctuation.special.tsx"] = { fg = "#d19f43" },
    TermCursor = { bg = "#eeeeee" },
  },
})
vim.cmd("colorscheme onedark_vivid")

-- Set nvim-notify as default notification handler
require("notify").setup({ max_width = 50, render = "wrapped-compact" })

vim.notify = require("notify")
-- ==================================================================================================
-- Autocmds

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" },
  { pattern = { "*" }, command = "setlocal nonumber | setlocal signcolumn=no" })

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*" }, command = [[%s/\s\+$//e]] })

-- Enable proper syntax highlighting for custom dotfiles
vim.api.nvim_create_autocmd({ "BufRead" },
  { pattern = { ".aliases", ".extra", ".functions" }, command = "setlocal syntax=sh ft=sh" })
vim.api.nvim_create_autocmd({ "BufRead" }, { pattern = { ".djlintrc" }, command = "setlocal syntax=json ft=json" })

-- Prevent weird wrapping after opening ( in comments in python files
vim.api.nvim_create_autocmd({ "FileType" }, { pattern = { "python" }, command = "setlocal indentkeys-=o" })

-- ==================================================================================================

-- PLUGIN SETUP

-- nvim-tree
require("nvim-tree").setup({ view = { adaptive_size = true } })

-- nvim-dap-repl-highlights
-- NOTE: This must be setup before nvim-treesitter.configs, otherwise
-- ensure_installed won't find the dap_repl parser
require("nvim-dap-repl-highlights").setup()

-- treesitter
require("nvim-treesitter.configs").setup({
  -- A list of parser names, or "all"
  ensure_installed = {
    "bash",
    "cmake",
    "css",
    "dap_repl",
    "dockerfile",
    "gitcommit",
    "git_config",
    "gitignore",
    "html",
    "java",
    "javascript",
    "json",
    "kotlin",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "yaml",
  },

  incremental_selection = {
    enable = true,
    keymaps = { init_selection = "<Enter>", node_incremental = "<Enter>", node_decremental = "<BS>" },
  },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
  },

  textobjects = {
    select = {
      enable = true,
      -- automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- ASSIGNMENT
        ["a="] = { query = "@assignment.outer", desc = "Select outer part of assignment" },
        ["i="] = { query = "@assignment.inner", desc = "Select inner part of assignment" },
        ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of assignment" },
        ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of assignment" },
        -- PARAMETER
        ["aa"] = { query = "@parameter.outer", desc = "Select outer part of parameter/argument" },
        ["ia"] = { query = "@parameter.inner", desc = "Select inner part of parameter/argument" },
        -- CONDITIONAL
        ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
        ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
        -- LOOP
        ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
        ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
        -- FUNCTION CALL
        ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
        ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
        -- FUNCTION
        ["am"] = { query = "@function.outer", desc = "Select outer part of a function definition" },
        ["im"] = { query = "@function.inner", desc = "Select inner part of a function definition" },
        -- CLASS
        ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        -- swap parameter with next
        ["<leader>na"] = "@parameter.inner",
        -- swap function with next
        ["<leader>nm"] = "@function.outer",
      },
      swap_previous = {
        -- swap parameter with next
        ["<leader>pa"] = "@parameter.inner",
        -- swap function with next
        ["<leader>pm"] = "@function.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = { query = "@call.outer", desc = "Next function call start" },
        ["]m"] = { query = "@function.outer", desc = "Next function definition start" },
        ["]c"] = { query = "@class.outer", desc = "Next class start" },
        ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
        ["]l"] = { query = "@loop.outer", desc = "Next loop start" },

        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]F"] = { query = "@call.outer", desc = "Next function call end" },
        ["]M"] = { query = "@function.outer", desc = "Next function definition end" },
        ["]C"] = { query = "@class.outer", desc = "Next class end" },
        ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
        ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
      },
      goto_previous_start = {
        ["[f"] = { query = "@call.outer", desc = "Previous function call start" },
        ["[m"] = { query = "@function.outer", desc = "Previous function definition start" },
        ["[c"] = { query = "@class.outer", desc = "Previous class start" },
        ["[i"] = { query = "@conditional.outer", desc = "Previous conditional start" },
        ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },

        ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
        ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
      },
      goto_previous_end = {
        ["[F"] = { query = "@call.outer", desc = "Previous function call end" },
        ["[M"] = { query = "@function.outer", desc = "Previous function definition end" },
        ["[C"] = { query = "@class.outer", desc = "Previous class end" },
        ["[I"] = { query = "@conditional.outer", desc = "Previous conditional end" },
        ["[L"] = { query = "@loop.outer", desc = "Previous loop end" },
      },
    },
  },
})

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

-- Mason
local language_servers = {
  "bashls",
  "cmake",
  "dockerls",
  "docker_compose_language_service",
  "emmet_language_server",
  "jsonls",
  "kotlin_language_server",
  "lua_ls",
  "pyright",
  "tsserver",
  "yamlls",
}
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = language_servers })

-- LSP
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint(bufnr, true) end

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
  vim.keymap.set("n", "gtd", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<leader>b", function() vim.lsp.buf.format{ async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
local lspconfig = require("lspconfig", { inlay_hints = { enable = true } })
for i in pairs(language_servers) do
  local server = language_servers[i]
  lspconfig[server].setup({ on_attach = on_attach, flags = lsp_flags })
end
lspconfig.emmet_language_server.setup({
  filetypes = {
    "css",
    "eruby",
    "html",
    "javascript",
    "javascriptreact",
    "jinja",
    "less",
    "sass",
    "scss",
    "svelte",
    "pug",
    "typescriptreact",
    "vue",
  },
  -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
  -- **Note:** only the options listed in the table are supported.
  init_options = {
    --- @type string[]
    excludeLanguages = {},
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
    preferences = {},
    --- @type boolean Defaults to `true`
    showAbbreviationSuggestions = true,
    --- @type "always" | "never" Defaults to `"always"`
    showExpandedAbbreviation = "always",
    --- @type boolean Defaults to `false`
    showSuggestionsAsSnippets = false,
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
    syntaxProfiles = { tag_nl = "decide", inline_break = 1 },
    --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
    variables = {},
  },
})
lspconfig.lua_ls.setup({
  -- ... other configs
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})

-- NOTE: Copilot needs to be set up before cmp
require("copilot").setup({
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = { jump_prev = "[[", jump_next = "]]", accept = "<leader>a", refresh = "gr", open = "<leader>cp" },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4,
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<c-t>",
      accept_word = false,
      accept_line = false,
      next = "<c-n>",
      prev = "<c-p>",
      dismiss = "<C-]>",
    },
  },
})

-- copilot-cmp
require("copilot_cmp").setup()

-- nvm-cmp
-- from: https://raw.githubusercontent.com/jdhao/nvim-config/master/lua/config/nvim-cmp.lua
local cmp = require("cmp")
local lspkind = require("lspkind")
lspkind.init({ symbol_map = { Copilot = "" } })

local lspkind_priority = require("cmp-lspkind-priority")
lspkind_priority.setup{
  -- Default priority by nvim-cmp
  priority = {
    "Snippet",
    "Field",
    "Variable",
    "Method",
    "Function",
    "Constructor",
    "Class",
    "Interface",
    "Module",
    "Property",
    "Unit",
    "Value",
    "Enum",
    "Keyword",
    "Color",
    "File",
    "Reference",
    "Folder",
    "EnumMember",
    "Constant",
    "Struct",
    "Event",
    "Operator",
    "TypeParameter",
    "Text",
  },
}

local compare = require("cmp.config.compare")

-- Required for copilot <tab> handling
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      -- For `ultisnips` user.
      vim.fn["UltiSnips#Anon"](args.body)
    end,

  },
  window = { documentation = cmp.config.window.bordered() },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = function(fallback)
      if cmp.visible() and has_words_before() then
        -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
    ["<CR>"] = cmp.mapping.confirm{ select = true },
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-q>"] = cmp.mapping.close(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
  }),
  sources = {
    { name = "ultisnips" }, -- For ultisnips user.
    { name = "copilot", group_index = 2 }, -- For github copilot
    { name = "nvim_lsp" }, -- For nvim-lsp
    { name = "nvim_lsp_signature_help" },
    { name = "path" }, -- For path completion
    { name = "buffer", keyword_length = 2 }, -- For buffer word completion
    { name = "omni" },
    { name = "treesitter" },
    { name = "emoji", insert = true }, -- emoji completion
  },
  completion = { keyword_length = 1, completeopt = "menu,noselect" },
  view = { entries = "custom" },
  formatting = {
    format = lspkind.cmp_format{
      mode = "symbol_text",
      menu = {
        nvim_lsp = "[LSP]",
        ultisnips = "[US]",
        nvim_lua = "[Lua]",
        path = "[Path]",
        buffer = "[Buffer]",
        emoji = "[Emoji]",
        omni = "[Omni]",
      },
    },
  },
  sorting = {
    comparators = {
      lspkind_priority.compare, -- Replaces `compare.kind` + first comparator
      compare.offset,
      compare.exact,
      require("copilot_cmp.comparators").prioritize, -- compare.scopes,
      compare.score,
      compare.recently_used,
      compare.locality,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
  experimental = { ghost_text = true },
})

-- Setup lspkind with nvim-cmp
-- from: https://github.com/onsails/lspkind.nvim
cmp.setup{
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol", -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item) return vim_item end,

    }),
  },
}

-- Trying cmp-nvim-lsp-signature-help instead
-- require("lsp_signature").setup()

-- neotest
require("neotest").setup({
  adapters = {
    require("neotest-python")({ dap = { justMyCode = false }, args = { "-vv" }, pytest_discover_instances = true }),
  },
  quickfix = { enabled = false },
})

-- dap-python
require("dap-python").setup("~/.pyenv/versions/.neovenv-3.11.5/bin/python3")
require("dap-python").test_runner = "pytest"
local dap = require("dap")

-- Enable if more detailed debug logs are needed
-- Logs available at lua print(vim.fn.stdpath('cache'))
-- dap.set_log_level('trace')

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Django",

    program = "${workspaceFolder}/manage.py",
    justMyCode = false,
    django = true,
    args = { "start", "--frontend=none", "--noreload" },
    console = "integratedTerminal",
    pythonPath = function() return os.getenv("VIRTUAL_ENV") .. "/bin/python" end,

  },
  {
    type = "python",
    request = "launch",
    name = "Python",

    program = "${file}",
    justMyCode = false,
    pythonPath = function() return os.getenv("VIRTUAL_ENV") .. "/bin/python" end,

  },
}

-- null-ls
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
  sources = {
    -- formatting
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.djlint.with({
      filetypes = { "django", "jinja.html", "htmldjango", "jinja" },
      extra_args = { "--configuration", vim.fn.expand("~/.djlintrc") },
    }),
    null_ls.builtins.formatting.lua_format.with({
      extra_args = { "--config=" .. vim.fn.expand("~/.config/lua-format/config.yaml") },
    }),
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.ruff,
    null_ls.builtins.diagnostics.checkmake,
    null_ls.builtins.diagnostics.djlint.with({ filetypes = { "django", "jinja.html", "htmldjango", "jinja" } }),
    null_ls.builtins.diagnostics.ruff,
    null_ls.builtins.diagnostics.eslint_d.with({ diagnostics_format = "[eslint] #{m}\n(#{c})" }), -- code actions
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.shellcheck,
  },
  -- format on save
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        group = augroup,
        buffer = bufnr,
        callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,

      })
    end
  end,

})

-- gitsigns
require("gitsigns").setup()

-- outline.nvim
require("outline").setup({
  outline_window = { width = 80, relative_width = false },
  symbol_folding = { autofold_depth = 1 },
  preview_window = { border = "rounded", live = true },
  keymaps = { close = {} },
})
vim.api.nvim_set_keymap("n", "<leader>ol", ":Outline<CR>", { noremap = true, silent = true })

-- octo
require("octo").setup({ ssh_aliases = { ["github.com-craigrosie"] = "github.com" } })

-- todo-comments
require("todo-comments").setup({ highlight = { keyword = "wide_fg" } })

-- barbecue
require("barbecue").setup({ create_autocmd = true })

-- openingh.vim
vim.keymap.set({ "n", "v" }, "<leader>gh", ":OpenInGHFile<CR>")

-- goto-preview
require("goto-preview").setup({
  width = 150, -- Width of the floating window
  height = 25, -- Height of the floating window
  post_open_hook = function(buf_handle, win_handle)
    vim.cmd("normal zt")
    -- Set a keymap that will close the floating window
    vim.api.nvim_buf_set_keymap(buf_handle, "n", "<Esc>",
      ("<Cmd>call nvim_win_close(%d, v:false)<CR>"):format(win_handle), { noremap = true })
  end,

})
vim.api
  .nvim_set_keymap("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<c-g>", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
  { noremap = true })
vim.api.nvim_set_keymap("n", "gpq", "<cmd>lua require('goto-preview').close_all_win()<CR>", { noremap = true })

-- dap-ui
require("dapui").setup({
  icons = { expanded = "", collapsed = ">", current_frame = "➜" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Use this to override mappings for specific elements
  element_mappings = {
    -- Example:
    -- stacks = {
    --   open = "<CR>",
    --   expand = "o",
    -- }
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 0.20,
      position = "left",
    },
    { elements = { "repl", "console" }, size = 0.25, position = "bottom" },
  },
  controls = {
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "",
      terminate = "",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = { close = { "q", "<Esc>" } },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  },
})

-- Open dap-ui automatically
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end

dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end

dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- neoscroll
require("neoscroll").setup()

require("indent_blankline").setup{ show_current_context = true, show_current_context_start = false }

-- nvim-pytrize
require("pytrize").setup()
vim.keymap.set("n", "gf", ":PytrizeJumpFixture<cr>", { noremap = true, silent = true })

-- mini.nvim
require("mini.ai").setup()
require("mini.comment").setup()
require("mini.pairs").setup()
-- require('mini.statusline').setup()
require("mini.surround").setup()

-- nvim-dap-virtual-text
require("nvim-dap-virtual-text").setup()

-- nvim-treesitter-context
require("treesitter-context").setup()

-- local-highlight
require("local-highlight").setup({})

-- lualine

local function min_window_width(width) return function() return vim.fn.winwidth(0) > width end end

require("lualine").setup{
  options = {
    icons_enabled = true,
    theme = "codedark",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { statusline = {}, winbar = {} },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
  },
  sections = {
    lualine_a = { { "mode", fmt = function(str) return str:sub(1, 1) end } },
    lualine_b = {
      -- { 'branch', cond = min_window_width(80) },
      -- 'diff',
      -- 'diagnostics',
    },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { "fzf", "nvim-dap-ui", "nvim-tree", "toggleterm" },
}

-- lsp-lens
require("lsp-lens").setup({})

-- glance
require("glance").setup({
  height = 25,
  border = {
    enable = false, -- Show window borders. Only horizontal borders allowed
    top_char = "―",
    bottom_char = "―",
  },
  theme = { -- This feature might not work properly in nvim-0.7.2
    enable = true, -- Will generate colors for the plugin based on your current colorscheme
    mode = "darken", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
  },
  detached = true,
})
vim.keymap.set("n", "<leader>gr", ":Glance references<CR>")
vim.keymap.set("n", "<leader>gd", ":Glance definitions<CR>")
vim.keymap.set("n", "<leader>gt", ":Glance type_definitions<CR>")

-- nvim-scrollbar
require("scrollbar.handlers.gitsigns").setup()
require("scrollbar").setup()

-- nvim-lastplace
require("nvim-lastplace").setup{
  lastplace_ignore_buftype = { "quickfix", "nofile", "help", "terminal" },
  lastplace_ignore_filetype = { "gitcommit", "gitrebase", "fzf" },
}

-- close-buffers.nvim
require("close_buffers").setup({ preserve_window_layout = { "this" } })
vim.keymap.set("n", "<leader>cb", ":lua require('close_buffers').delete({type = 'hidden'})<CR>")

-- hlargs.nvim
require("hlargs").setup{
  color = "#e88f29", -- same as @parameter
  excluded_argnames = { declarations = {}, usages = { python = { "self", "cls" }, lua = { "self" } } },
}

-- prettier.nvim
local prettier = require("prettier")

prettier.setup({
  bin = "prettierd", -- or `'prettierd'` (v0.23.3+)
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})

-- overseer.nvim
require("overseer").setup()
vim.keymap.set("n", "<leader>or", ":OverseerRun<CR>")
vim.keymap.set("n", "<leader>ot", ":OverseerTaskAction<CR>")

-- nvim-spider
require("spider").setup{ skipInsignificantPunctuation = true }

vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })

-- modes.nvim
require("modes").setup()

require("auto-session").setup({
  log_level = "info",
  auto_session_enable_last_session = false,
  auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
  auto_session_enabled = true,
  auto_save_enabled = nil,
  auto_restore_enabled = nil,
  auto_session_suppress_dirs = nil,
  auto_session_use_git_branch = nil,
  -- the configs below are lua only
  bypass_session_save_file_types = nil,
  pre_save_cmds = { "FloatermKill!", "OutlineClose", "NvimTreeClose", "lua vim.notify.dismiss()" },
})

-- oil.nvim
require("oil").setup({ view_options = { show_hidden = true }, float = { max_width = 120, max_height = 70 } })
vim.keymap.set("n", "<C-t>", ":Oil --float<CR>")

-- =================================================================================================

-- KEY MAPPINGS

vim.keymap.set("n", "<Enter>", "ciw")
vim.keymap.set("n", "<C-w><space>", ":vsplit<CR>")

-- Open nvim-tree
vim.keymap.set("n", "<C-n>", ":NvimTreeFocus <CR>")

-- Vertical visual movement when lines are wrapped
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Adjust viewports to the same size
vim.keymap.set("n", "<leader>=", "<C-w>=")

-- Adjust split size
vim.keymap.set("n", "<leader>]", ":vertical resize +10<CR>")
vim.keymap.set("n", "<leader>[", ":vertical resize -10<CR>")

-- Get unstuck from blocked popup window
vim.keymap.set("n", "<leader>quit", ":call popup_close(win_getid())<CR>")

-- Custom mapping for jumping forward in the jumplist
vim.keymap.set("n", "<C-m>", "<C-i>")

-- Basic movement between splits
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- Remove search highlighting
vim.keymap.set("n", "<leader><space>", ":noh <CR>")

-- fzf-lua
require("fzf-lua").setup({ lsp = { async_or_timeout = true } })
vim.api.nvim_set_keymap("n", "<leader>fp", "<cmd>lua require('fzf-lua').git_files()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ff",
  "<cmd>lua require('fzf-lua').files({ cwd_prompt = false, prompt = 'Files❯ ' })<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fr", "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ft", "<cmd>lua require('fzf-lua').tabs()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('fzf-lua').grep_project()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fn", "<cmd>lua require('fzf-lua').live_grep_glob()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fx", ":FzfLua live_grep cwd=", { noremap = true })
vim.api.nvim_set_keymap("v", "<leader>fv", "<cmd>lua require('fzf-lua').grep_visual()<CR>",
  { noremap = true, silent = true })
vim.api
  .nvim_set_keymap("n", "<leader>fm", "<cmd>lua require('fzf-lua').resume()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fq", "<cmd>lua require('fzf-lua').quickfix()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fl", "<cmd>lua require('fzf-lua').loclist()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>flr", "<cmd>lua require('fzf-lua').lsp_references()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fli", "<cmd>lua require('fzf-lua').lsp_incoming_calls()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fld", "<cmd>lua require('fzf-lua').lsp_definitions()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fk", "<cmd>lua require('fzf-lua').keymaps()<CR>",
  { noremap = true, silent = true })

-- neotest
-- https://alpha2phi.medium.com/neovim-for-beginners-testing-part-2-10d4aa8f25d6
vim.keymap.set("n", "<leader>tf", ":lua require('neotest').run.run({vim.fn.expand('%')})<cr>") -- run file
vim.keymap.set("n", "<leader>tn", ":lua require('neotest').run.run()<cr>") -- run nearest
vim.keymap.set("n", "<leader>ta", ":lua require('neotest').run.attach()<cr>") -- attach to nearest nearest
vim.keymap.set("n", "<leader>ts", ":lua require('neotest').run.stop()<cr>") -- stop nearest nearest
vim.keymap.set("n", "<leader>td", ":lua require('neotest').run.run({strategy = 'dap'})<cr>") -- debug nearest
vim.keymap.set("n", "<leader>to", ":lua require('neotest').output.open({ enter = true })<cr>") -- show test output
vim.keymap.set("n", "<leader>tp", ":lua require('neotest').output_panel.toggle()<cr>") -- toggle output panel
vim.keymap.set("n", "<leader>tt", ":lua require('neotest').summary.toggle()<cr>") -- toggle test summary

-- dap & dap-ui
-- https://davelage.com/posts/nvim-dap-getting-started/
vim.keymap.set("n", "<leader>db", ":lua require('dap').toggle_breakpoint()<cr>") -- toggle breakpoint
vim.keymap.set("n", "<leader>dx", ":lua require('dap').clear_breakpoints()<cr>") -- toggle breakpoint
vim.keymap.set("n", "<leader>dc", ":lua require('dap').continue()<cr>") -- continue
vim.keymap.set("n", "<leader>do", ":lua require('dap').step_over()<cr>") -- step_over
vim.keymap.set("n", "<leader>di", ":lua require('dap').step_into()<cr>") -- step into
vim.keymap.set("n", "<leader>du", ":lua require('dap').step_out()<cr>") -- step_out
vim.keymap.set("n", "<leader>d[", ":lua require('dap').up()<cr>") -- go up in stacktrace without stepping
vim.keymap.set("n", "<leader>d]", ":lua require('dap').down()<cr>") -- go down in stacktrace without stepping
vim.keymap.set("n", "<leader>dr", ":lua require('dap').run_to_cursor()<cr>") -- open repl
vim.keymap.set("n", "<leader>de", ":lua require('dap').terminate()<cr>") -- terminate (exit)
vim.keymap.set("n", "<leader>dt", ":lua require('dapui').toggle()<cr>") -- toggle dap-ui

-- vim-floaterm
-- List floaterms using fzf
-- <C-w>l hack to ensure floaterm always opens in right split
vim.keymap.set("n", "<leader>i", "<C-w>l<C-w>l<C-w>l<cmd>Floaterms<CR>")
-- Open new floaterm with hardcoded (iterm) name
vim.keymap.set("n", "<leader>q",
  "<C-w>l<C-w>l<C-w>l<cmd>FloatermNew --wintype=vsplit --height=1.0 --width=120 --title=iterm --position=right --autoclose=0<CR>")
-- Allow specifying the name of the floaterm before opening
vim.keymap.set("n", "<leader>qn",
  "<C-w>l<C-w>l<C-w>l:FloatermNew --wintype=vsplit --height=1.0 --width=120 --position=right --autoclose=0 --title=")
-- Shortcut to hide all floaterms
vim.keymap.set("n", "<leader>qt", "<cmd>FloatermHide!<CR>")
-- Shortcut for killing a floaterm - allows a floaterm name to be entered before killing
vim.keymap.set("n", "<leader>qk", ":FloatermKill")
-- Shortcut to open lazygit in a floaterm
vim.keymap.set("n", "<leader>qg", "<cmd>FloatermNew --title=lazygit --width=0.75 --height=0.9 lazygit<CR>")
-- Allow normal window-switching mappings from floaterm
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-e>", "<C-\\><C-n>")

-- nvim-osc52
vim.keymap.set("n", "<leader>c", require("osc52").copy_operator, { expr = true })
vim.keymap.set("n", "<leader>cc", "<leader>c_", { remap = true })
vim.keymap.set("x", "<leader>c", require("osc52").copy_visual)

vim.keymap.set("n", "<leader>r", ":so $MYVIMRC<CR>")

-- lua
vim.keymap.set("n", "<leader>lf", ":luafile %<CR>")
vim.keymap.set("n", "<leader>r", ":so $MYVIMRC<CR>")

-- indent while remaining in visual mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- keep cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll downwards" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll upwards" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous result" })
vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "Previous result" })

-- execute macro over a visual region.
vim.keymap.set("x", "@", function() return ":norm @" .. vim.fn.getcharstr() .. "<cr>" end, { expr = true })
