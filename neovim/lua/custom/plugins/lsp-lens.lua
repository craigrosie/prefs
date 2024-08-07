return {
  'VidocqH/lsp-lens.nvim',
  dependencies = {},
  event = 'VeryLazy',
  opts = {
    enable = false,
  },
  keys = {
    { '<leader>ll', ':LspLensToggle<cr>', desc = '[l]sp lens toggle' },
  },
}
