-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Set filetype to snippets for .snippets files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.snippets',
  callback = function()
    vim.bo.filetype = 'snippets'
    vim.bo.syntax = 'snippets'
    -- NOTE: These need to be set in a modeline otherwise they're overwritten by tpope/vim-sleuth
    -- vim.bo.tabstop = 2
    -- vim.bo.shiftwidth = 2
  end,
})

-- Set filetype to bash for various files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = {
    '.aliases',
    '.bash_profile',
    '.bashrc',
    '.extra',
    '.functions',
    '.sensible',
    '.envrc*',
  },
  callback = function()
    vim.bo.filetype = 'bash'
    vim.bo.syntax = 'bash'
  end,
})

-- Start git commits at start of line, and insert mode if message is empty
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gitcommit',
  callback = function()
    vim.wo.spell = true
    if vim.fn.getline(1) == '' then
      vim.cmd('startinsert!')
    end
  end,
})

-- For heirarchy.nvim
vim.api.nvim_create_augroup('Hierarchy', { clear = true })
vim.api.nvim_create_autocmd({ 'LspAttach' }, {
  group = 'Hierarchy',
  desc = 'Set up the :FunctionReferences user command',
  callback = function()
    local opts = {
      depth = 3,
    }
    require('hierarchy').setup(opts)
  end,
})
