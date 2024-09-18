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

-- Set filetype to bash for .envrc files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '.envrc*',
  callback = function()
    vim.bo.filetype = 'bash'
    vim.bo.syntax = 'bash'
  end,
})
