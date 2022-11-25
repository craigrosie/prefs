-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- pyenv virtualenv with neovim package installed
vim.g.python3_host_prog = "/Users/craigrosie/.pyenv/versions/neovim-3.11.0/bin/python3"

require('plugins')

-- Set custom colours for colourscheme
require('onedark').setup({
  style = 'warmer',
  highlights = {
    ["@comment"] = {fg = "#232326", bg = "#222222"},
    ["@preproc"] = {fg = "#232326", bg = "#888888"},
    ["@field"] = {fg = "#dddddd"},
    ["@variable"] = {fg = "#dddddd"},
    ["@number"] = {fg = "#bb70d2"},
    ["@constant.builtin"] = {fg = "#bb70d2"},
    ["@string"] = {fg = "$yellow"},
    ["@punctuation.bracket"] = {fg = "$yellow"},
    ["@function"] = {fg = "#A6E22E"},
    ["@function.builtin"] = {fg = "#4DF6E8"},
    ["@function.call"] = {fg = "#A6E22E"},
    ["@constructor"] = {fg = "#A6E22E"},
    ["@method.call"] = {fg = "#A6E22E"},
    ["@type"] = {fg = "#618b82"},
    ["@keyword.function"] = {fg = "#FF0000", fmt = 'bold'},
    ["@keyword.return"] = {fg = "#FF0000", fmt = 'bold'},
    ["@keyword.operator"] = {fg = "#FF0000", fmt = 'bold'},
    ["@repeat"] = {fg = "#FF0000", fmt = 'bold'},
    ["@conditional"] = {fg = "#FF0000", fmt = 'bold'},
    ["@include"] = {fg = "#FF0000", fmt = 'bold'},
    ["@parameter"] = {fg = "#e88f29"},
  }
})
require('onedark').load()


-- Set leader key to <space>
vim.g.mapleader = ' '

-- Some sensible defaults
vim.o.termguicolors = true
vim.o.syntax = 'on'
vim.o.errorbells = false
vim.o.smartcase = true
vim.o.showmode = false
vim.bo.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.completeopt='menuone,noinsert,noselect'
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.wo.number = true
vim.wo.signcolumn = 'yes'
vim.wo.wrap = false
vim.opt.colorcolumn="80,100"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 3
vim.opt.sidescrolloff=3
vim.opt.cursorline = true

-- ==================================================================================================
-- Autocmds

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd(
    { "TermOpen", "TermEnter" },
    { pattern = { "*" }, command = "setlocal nonumber | setlocal signcolumn=no" }
)

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd(
    { "BufWritePre" },
    { pattern = { "*" }, command = [[%s/\s\+$//e]]}
)

-- ==================================================================================================

-- PLUGIN SETUP

-- nvim-tree
require("nvim-tree").setup()

-- treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "lua"},

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
  },
  -- enable treesitter playground, can helping with finding treesitter "types"
  -- for modifying colourschems etc
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

-- Mason
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { "sumneko_lua", "pyright" }
})


-- LSP
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', 'gtd', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>b', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

-- nvm-cmp
-- from: https://raw.githubusercontent.com/jdhao/nvim-config/master/lua/config/nvim-cmp.lua
local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup {
  snippet = {
    expand = function(args)
      -- For `ultisnips` user.
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
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
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-q>"] = cmp.mapping.close(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
  },
  sources = {
    { name = "nvim_lsp" }, -- For nvim-lsp
    { name = "ultisnips" }, -- For ultisnips user.
    { name = "path" }, -- for path completion
    { name = "buffer", keyword_length = 2 }, -- for buffer word completion
    { name = "omni" },
    { name = "emoji", insert = true }, -- emoji completion
  },
  completion = {
    keyword_length = 1,
    completeopt = "menu,noselect",
  },
  view = {
    entries = "custom",
  },
  formatting = {
    format = lspkind.cmp_format {
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
}

-- Setup lspkind with nvim-cmp
-- from: https://github.com/onsails/lspkind.nvim
local lspkind = require('lspkind')
cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function (entry, vim_item)
        return vim_item
      end
    })
  }
}

require("lsp_signature").setup()

-- neotest
require("neotest").setup({
  adapters = {
    require("neotest-python")
  }
})

-- dap-python
require('dap-python').setup('~/.pyenv/versions/debugpy-3.11.0/bin/python')
require('dap-python').test_runner = 'pytest'

-- null-ls
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
      null_ls.builtins.formatting.isort,
      null_ls.builtins.formatting.black,
    },
})

-- gitsigns
require('gitsigns').setup()

-- symbols-outline.nvim
require("symbols-outline").setup({
  width = 20,
  autofold_depth = 1,
})
vim.keymap.set('n', '<leader>so', ":SymbolsOutline<CR>")

-- octo
require("octo").setup({
  ssh_aliases = {
    ["github.com-craigrosie"] = "github.com"
  }
})

-- todo-comments
require("todo-comments").setup({
  highlight = {
    keyword="wide_fg",
  }
})

-- =================================================================================================

-- KEY MAPPINGS
-- Open nvim-tree
vim.keymap.set('n', '<C-n>', ':NvimTreeFocus <CR>')

-- Vertical visual movement when lines are wrapped
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- Adjust viewports to the same size
vim.keymap.set('n', '<leader>=', '<C-w>=')

-- Adjust split size
vim.keymap.set('n', '<leader>]', ':vertical resize +10<CR>')
vim.keymap.set('n', '<leader>[', ':vertical resize -10<CR>')

-- Get unstuck from blocked popup window
vim.keymap.set('n', '<leader>quit', ':call popup_close(win_getid())<CR>')

-- Custom mapping for jumping forward in the jumplist
vim.keymap.set('n', '<C-m>', '<C-i>')

-- Basic movement between splits
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')

-- Remove search highlighting
vim.keymap.set('n', '<leader><space>', ':noh <CR>')

-- fzf-lua
vim.api.nvim_set_keymap('n', '<leader>fp', "<cmd>lua require('fzf-lua').git_files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fr', "<cmd>lua require('fzf-lua').btags()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ft', "<cmd>lua require('fzf-lua').tags()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('fzf-lua').grep_project()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fm', "<cmd>lua require('fzf-lua').resume()<CR>", { noremap = true, silent = true })

-- neotest
-- https://alpha2phi.medium.com/neovim-for-beginners-testing-part-2-10d4aa8f25d6
vim.keymap.set('n', '<leader>tf', ":lua require('neotest').run.run({vim.fn.expand('%')})<cr>")  -- run file
vim.keymap.set('n', '<leader>tn', ":lua require('neotest').run.run()<cr>")  -- run nearest
vim.keymap.set('n', '<leader>ta', ":lua require('neotest').run.attach()<cr>")  -- attach to nearest nearest
vim.keymap.set('n', '<leader>td', ":lua require('neotest').run.run({strategy = 'dap'})<cr>")  -- debug nearest
vim.keymap.set('n', '<leader>to', ":lua require('neotest').output.open({ enter = true })<cr>")  -- show test output

-- dap
-- https://davelage.com/posts/nvim-dap-getting-started/
vim.keymap.set('n', '<leader>db', ":lua require('dap').toggle_breakpoint()<cr>")  -- toggle breakpoint
vim.keymap.set('n', '<leader>dc', ":lua require('dap').continue()<cr>")  -- continue
vim.keymap.set('n', '<leader>do', ":lua require('dap').step_over()<cr>")  -- step_over
vim.keymap.set('n', '<leader>di', ":lua require('dap').step_into()<cr>")  -- step into
vim.keymap.set('n', '<leader>du', ":lua require('dap').step_out()<cr>")  -- step_out
vim.keymap.set('n', '<leader>dr', ":lua require('dap').repl.open()")  -- open repl

-- vim-floaterm
-- List floaterms using fzf
-- <C-w>l hack to ensure floaterm always opens in right split
vim.keymap.set('n', '<leader>i', "<C-w>l<C-w>l<C-w>l:Floaterms<CR>")
-- Open new floaterm with hardcoded (iterm) name
vim.keymap.set('n', '<leader>q', "<C-w>l<C-w>l<C-w>l:FloatermNew --wintype=vsplit --height=1.0 --width=0.33 --title=iterm --position=right --autoclose=0<CR>")
-- Allow specifying the name of the floaterm before opening
vim.keymap.set('n', '<leader>qn', "<C-w>l<C-w>l<C-w>l:FloatermNew --wintype=vsplit --height=1.0 --width=0.33 --position=right --autoclose=0 --title=")
-- Shortcut to hide all floaterms
vim.keymap.set('n', '<leader>qt', ":FloatermHide!<CR>")
-- Shortcut for killing a floaterm - allows a floaterm name to be entered before killing
vim.keymap.set('n', '<leader>qk', ":FloatermKill")
-- Allow normal window-switching mappings from floaterm
vim.keymap.set('t', '<C-h>', "<C-\\><C-n><C-w>h")
vim.keymap.set('t', '<C-j>', "<C-\\><C-n><C-w>j")
vim.keymap.set('t', '<C-k>', "<C-\\><C-n><C-w>k")
vim.keymap.set('t', '<C-l>', "<C-\\><C-n><C-w>l")

-- Ack.vim
-- Don't jump to first result when searching with ack.vim
vim.keymap.set('n', '<leader>a', ":Ack! -Q<Space>")
-- Search for word under cursor with ack.vim
vim.keymap.set('n', '<leader>af', ":Ack! <C-W> <CR>")

-- UltiSnips
vim.g.UltiSnipsSnippetDirectories = {"UltiSnips", "custom_snippets"}
-- trigger snippet expansion
vim.g.UltiSnipsExpandTrigger='<c-e>'
-- shortcut to go to next position
vim.g.UltiSnipsJumpForwardTrigger='<c-j>'
-- shortcut to go to previous position
vim.g.UltiSnipsJumpBackwardTrigger='<c-k>'
vim.keymap.set('n', '<leader>u', ":call UltiSnips#RefreshSnippets()<CR>")

-- lua
vim.keymap.set('n', '<leader>lf', ":luafile %<CR>")
