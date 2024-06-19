return {
  'stevearc/oil.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    view_options = { show_hidden = true },
    float = { max_width = 120, max_height = 70 },
  },
  keys = {
    { '<C-t>', ':Oil --float<CR>', desc = 'Oil' },
  },
}
