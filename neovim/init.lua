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
    ["@comment"] = { fg = "#232326", bg = "#222222" },
    ["@preproc"] = { fg = "#232326", bg = "#888888" },
    ["@field"] = { fg = "#dddddd" },
    ["@variable"] = { fg = "#dddddd" },
    ["@number"] = { fg = "#bb70d2" },
    ["@constant.builtin"] = { fg = "#bb70d2" },
    ["@boolean"] = { fg = "#bb70d2" },
    ["@constant"] = { fg = "#bb70d2" },
    ["@string"] = { fg = "$yellow" },
    ["@punctuation.bracket"] = { fg = "$yellow" },
    ["@function"] = { fg = "#A6E22E" },
    ["@function.builtin"] = { fg = "#4DF6E8" },
    ["@function.call"] = { fg = "#A6E22E" },
    ["@method"] = { fg = "#A6E22E" },
    ["@constructor"] = { fg = "#A6E22E" },
    ["@method.call"] = { fg = "#A6E22E" },
    ["@type"] = { fg = "#618b82" },
    ["@keyword.function"] = { fg = "#FF0000", fmt = 'bold' },
    ["@keyword.return"] = { fg = "#FF0000", fmt = 'bold' },
    ["@keyword.operator"] = { fg = "#FF0000", fmt = 'bold' },
    ["@repeat"] = { fg = "#FF0000", fmt = 'bold' },
    ["@conditional"] = { fg = "#FF0000", fmt = 'bold' },
    ["@include"] = { fg = "#FF0000", fmt = 'bold' },
    ["@parameter"] = { fg = "#e88f29" },
    ["@text.diff.add"] = { fg = "#08BE14" },
    ["@text.diff.delete"] = { fg = "#E20505" },
    ["GlancePreviewMatch"] = { fg = '#dcd7ba', bg = '#484e52' },
    ["GlanceListMatch"] = { fg = '#dcd7ba', bg = '#484e52' },
  }
})
require('onedark').load()


-- Set leader key to <space>
vim.g.mapleader = ' '

-- Some sensible defaults
vim.o.backup = false
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.errorbells = false
vim.o.expandtab = true
vim.o.hidden = true
vim.o.incsearch = true
vim.o.shiftwidth = 2
vim.o.showmode = false
vim.o.smartcase = true
vim.o.softtabstop = 2
vim.o.syntax = 'on'
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.o.undofile = true
vim.o.updatetime = 350
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.bo.swapfile = false
vim.wo.number = true
vim.wo.signcolumn = 'yes'
vim.wo.wrap = false
vim.opt.colorcolumn = "80,120"
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
-- Completely disable editorconfig integration, as the max_line_length field
-- sets `textwidth` which is never what I want
vim.g.editorconfig = false
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
  { pattern = { "*" }, command = [[%s/\s\+$//e]] }
)

-- Enable proper syntax highlighting for custom dotfiles
vim.api.nvim_create_autocmd(
  { "BufRead" },
  { pattern = { ".aliases", ".extra", ".functions" }, command = "setlocal syntax=sh ft=sh" }
)

-- ==================================================================================================

-- PLUGIN SETUP

-- nvim-tree
require("nvim-tree").setup()

-- treesitter
require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    "bash",
    "cmake",
    "dockerfile",
    "javascript",
    "json",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "toml",
    "tsx",
    "typescript",
    "yaml",
  },

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
local language_servers = {
  "bashls",
  "cmake",
  "dockerls",
  "docker_compose_language_service",
  "jsonls",
  "lua_ls",
  "pyright",
  "taplo",
  "tsserver",
  "yamlls",
}
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = language_servers
})


-- LSP
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, opts)
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
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
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
for i in pairs(language_servers) do
  local server = language_servers[i]
  require('lspconfig')[server].setup({
    on_attach = on_attach,
    flags = lsp_flags,
  })
end

-- nvm-cmp
-- from: https://raw.githubusercontent.com/jdhao/nvim-config/master/lua/config/nvim-cmp.lua
local cmp = require("cmp")
local lspkind = require("lspkind")

local lspkind_priority = require('cmp-lspkind-priority')
lspkind_priority.setup {
  -- Default priority by nvim-cmp
  priority = {
    'Snippet',
    'Field',
    'Variable',
    'Method',
    'Function',
    'Constructor',
    'Class',
    'Interface',
    'Module',
    'Property',
    'Unit',
    'Value',
    'Enum',
    'Keyword',
    'Color',
    'File',
    'Reference',
    'Folder',
    'EnumMember',
    'Constant',
    'Struct',
    'Event',
    'Operator',
    'TypeParameter',
    'Text',
  }
}

local compare = require('cmp.config.compare')

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
    { name = "ultisnips" }, -- For ultisnips user.
    { name = "nvim_lsp" }, -- For nvim-lsp
    { name = "path" }, -- for path completion
    { name = "buffer", keyword_length = 2 }, -- for buffer word completion
    { name = "omni" },
    { name = 'treesitter' },
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
  sorting = {
    comparators = {
      lspkind_priority.compare, -- Replaces `compare.kind` + first comparator
      compare.offset,
      compare.exact,
      -- compare.scopes,
      compare.score,
      compare.recently_used,
      compare.locality,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
  experimental = {
    ghost_text = true,
  },
}

-- Setup lspkind with nvim-cmp
-- from: https://github.com/onsails/lspkind.nvim
cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        return vim_item
      end
    })
  }
}

require("lsp_signature").setup()

-- neotest
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
      args = { "-vv" }
    })
  },
  quickfix = {
    enabled = false
  }
})

-- dap-python
require('dap-python').setup('~/.pyenv/versions/debugpy-3.11.0/bin/python')
require('dap-python').test_runner = 'pytest'
local dap = require('dap')

-- Enable if more detailed debug logs are needed
-- Logs available at lua print(vim.fn.stdpath('cache'))
-- dap.set_log_level('trace')

dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = "Django";

    program = '${workspaceFolder}/manage.py';
    justMyCode = false;
    django = true;
    args = { "start", "--frontend=none", "--noreload" };
    console = "integratedTerminal";
    pythonPath = function()
      return os.getenv("VIRTUAL_ENV") .. "/bin/python"
    end;
  },
  {
    type = 'python';
    request = 'launch';
    name = "Python";

    program = '${file}';
    justMyCode = false;
    pythonPath = function()
      return os.getenv("VIRTUAL_ENV") .. "/bin/python"
    end;
  },
}

-- null-ls
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
  sources = {
    -- formatting
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.lua_format,
    null_ls.builtins.formatting.ruff,
    null_ls.builtins.formatting.taplo,
    -- linting
    null_ls.builtins.diagnostics.checkmake,
    null_ls.builtins.diagnostics.ruff,
    -- code actions
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
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
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
    keyword = "wide_fg",
  }
})

-- barbecue
require("barbecue").setup({
  create_autocmd = true
})

-- openingh.vim
vim.keymap.set({ 'n', 'v' }, '<leader>gh', ':OpenInGHFile<CR>')

-- goto-preview
require("goto-preview").setup({
  width = 150; -- Width of the floating window
  height = 25; -- Height of the floating window
})
vim.api.nvim_set_keymap("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true })
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
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25,
      position = "bottom",
    },
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
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})

-- Open dap-ui automatically
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- neoscroll
require('neoscroll').setup()

require("indent_blankline").setup {
  show_current_context = true,
  show_current_context_start = true,
}

-- nvim-pytrize
require("pytrize").setup()
vim.keymap.set('n', 'gf', ":PytrizeJumpFixture<cr>", { noremap = true, silent = true })

-- mini.nvim
require('mini.ai').setup()
require('mini.comment').setup()
-- require('mini.pairs').setup()
-- require('mini.statusline').setup()
require('mini.surround').setup()

-- nvim-dap-virtual-text
require("nvim-dap-virtual-text").setup()

-- nvim-treesitter-context
require('treesitter-context').setup()

-- local-highlight
require('local-highlight').setup({})

-- lualine

local function min_window_width(width)
  return function() return vim.fn.winwidth(0) > width end
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'codedark',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {
      {
        'mode',
        fmt = function(str) return str:sub(1, 3) end,
      }
    },
    lualine_b = {
      { 'branch', cond = min_window_width(80) },
      'diff',
      'diagnostics',
    },
    lualine_c = {
      {
        'filename',
        path = 1,
      }
    },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        path = 1,
      }
    },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { 'fzf', 'nvim-dap-ui', 'nvim-tree', 'symbols-outline', 'toggleterm' }
}

-- lsp-lens
-- require('lsp-lens').setup({})

-- glance
require('glance').setup({
  height = 25,
  border = {
    enable = false, -- Show window borders. Only horizontal borders allowed
    top_char = '―',
    bottom_char = '―',
  },
  theme = { -- This feature might not work properly in nvim-0.7.2
    enable = true, -- Will generate colors for the plugin based on your current colorscheme
    mode = 'darken', -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
  },
  detached = true,
})
vim.keymap.set('n', '<leader>gr', ':Glance references<CR>')
vim.keymap.set('n', '<leader>gd', ':Glance definitions<CR>')
vim.keymap.set('n', '<leader>gt', ':Glance type_definitions<CR>')

-- nvim-scrollbar
require("scrollbar.handlers.gitsigns").setup()
require("scrollbar").setup()

-- nvim-lastplace
require('nvim-lastplace').setup {
  lastplace_ignore_buftype = { "quickfix", "nofile", "help", "terminal" },
  lastplace_ignore_filetype = { "gitcommit", "gitrebase", "fzf" },
}

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
require("fzf-lua").setup({
  lsp = {
    async_or_timeout = true,
  }
})
vim.api.nvim_set_keymap('n', '<leader>fp', "<cmd>lua require('fzf-lua').git_files()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fr', "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ft', "<cmd>lua require('fzf-lua').tabs()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('fzf-lua').grep_project()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fv', "<cmd>lua require('fzf-lua').grep_visual()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fm', "<cmd>lua require('fzf-lua').resume()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fq', "<cmd>lua require('fzf-lua').quickfix()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fl', "<cmd>lua require('fzf-lua').loclist()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>flr', "<cmd>lua require('fzf-lua').lsp_references()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fli', "<cmd>lua require('fzf-lua').lsp_incoming_calls()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fld', "<cmd>lua require('fzf-lua').lsp_definitions()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fk', "<cmd>lua require('fzf-lua').keymaps()<CR>", { noremap = true, silent = true })

-- neotest
-- https://alpha2phi.medium.com/neovim-for-beginners-testing-part-2-10d4aa8f25d6
vim.keymap.set('n', '<leader>tf', ":lua require('neotest').run.run({vim.fn.expand('%')})<cr>") -- run file
vim.keymap.set('n', '<leader>tn', ":lua require('neotest').run.run()<cr>") -- run nearest
vim.keymap.set('n', '<leader>ta', ":lua require('neotest').run.attach()<cr>") -- attach to nearest nearest
vim.keymap.set('n', '<leader>ts', ":lua require('neotest').run.stop()<cr>") -- stop nearest nearest
vim.keymap.set('n', '<leader>td', ":lua require('neotest').run.run({strategy = 'dap'})<cr>") -- debug nearest
vim.keymap.set('n', '<leader>to', ":lua require('neotest').output.open({ enter = true })<cr>") -- show test output
vim.keymap.set('n', '<leader>tp', ":lua require('neotest').output_panel.toggle()<cr>") -- toggle output panel
vim.keymap.set('n', '<leader>tt', ":lua require('neotest').summary.toggle()<cr>") -- toggle test summary

-- dap & dap-ui
-- https://davelage.com/posts/nvim-dap-getting-started/
vim.keymap.set('n', '<leader>db', ":lua require('dap').toggle_breakpoint()<cr>") -- toggle breakpoint
vim.keymap.set('n', '<leader>dx', ":lua require('dap').clear_breakpoints()<cr>") -- toggle breakpoint
vim.keymap.set('n', '<leader>dc', ":lua require('dap').continue()<cr>") -- continue
vim.keymap.set('n', '<leader>do', ":lua require('dap').step_over()<cr>") -- step_over
vim.keymap.set('n', '<leader>di', ":lua require('dap').step_into()<cr>") -- step into
vim.keymap.set('n', '<leader>du', ":lua require('dap').step_out()<cr>") -- step_out
vim.keymap.set('n', '<leader>d[', ":lua require('dap').up()<cr>") -- go up in stacktrace without stepping
vim.keymap.set('n', '<leader>d]', ":lua require('dap').down()<cr>") -- go down in stacktrace without stepping
vim.keymap.set('n', '<leader>dr', ":lua require('dap').run_to_cursor()<cr>") -- open repl
vim.keymap.set('n', '<leader>dt', ":lua require('dapui').toggle()<cr>") -- toggle dap-ui

-- vim-floaterm
-- List floaterms using fzf
-- <C-w>l hack to ensure floaterm always opens in right split
vim.keymap.set('n', '<leader>i', "<C-w>l<C-w>l<C-w>l:Floaterms<CR>")
-- Open new floaterm with hardcoded (iterm) name
vim.keymap.set('n', '<leader>q',
  "<C-w>l<C-w>l<C-w>l:FloatermNew --wintype=vsplit --height=1.0 --width=120 --title=iterm --position=right --autoclose=0<CR>")
-- Allow specifying the name of the floaterm before opening
vim.keymap.set('n', '<leader>qn',
  "<C-w>l<C-w>l<C-w>l:FloatermNew --wintype=vsplit --height=1.0 --width=120 --position=right --autoclose=0 --title=")
-- Shortcut to hide all floaterms
vim.keymap.set('n', '<leader>qt', ":FloatermHide!<CR>")
-- Shortcut for killing a floaterm - allows a floaterm name to be entered before killing
vim.keymap.set('n', '<leader>qk', ":FloatermKill")
-- Shortcut to open lazygit in a floaterm
vim.keymap.set('n', '<leader>qg', ":FloatermNew --title=lazygit --width=0.75 --height=0.9 lazygit<CR>")
-- Allow normal window-switching mappings from floaterm
vim.keymap.set('t', '<C-h>', "<C-\\><C-n><C-w>h")
vim.keymap.set('t', '<C-j>', "<C-\\><C-n><C-w>j")
vim.keymap.set('t', '<C-k>', "<C-\\><C-n><C-w>k")
vim.keymap.set('t', '<C-l>', "<C-\\><C-n><C-w>l")

-- UltiSnips
vim.g.UltiSnipsSnippetDirectories = { "UltiSnips", "custom_snippets" }
-- trigger snippet expansion
vim.g.UltiSnipsExpandTrigger = '<c-e>'
-- shortcut to go to next position
vim.g.UltiSnipsJumpForwardTrigger = '<c-j>'
-- shortcut to go to previous position
vim.g.UltiSnipsJumpBackwardTrigger = '<c-k>'
vim.keymap.set('n', '<leader>u', ":call UltiSnips#RefreshSnippets()<CR>")

-- nvim-osc52
vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, { expr = true })
vim.keymap.set('n', '<leader>cc', '<leader>c_', { remap = true })
vim.keymap.set('x', '<leader>c', require('osc52').copy_visual)

-- lua
vim.keymap.set('n', '<leader>lf', ":luafile %<CR>")
