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
