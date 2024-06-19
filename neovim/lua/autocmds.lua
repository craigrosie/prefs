-- Set filetype to snippets for .snippets files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.snippets',
  callback = function()
    vim.bo.filetype = 'snippets'
    vim.bo.syntax = 'snippets'
  end,
})
