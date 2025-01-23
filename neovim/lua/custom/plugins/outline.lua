return {
  'hedyhli/outline.nvim',
  lazy = true,
  cmd = { 'Outline', 'OutlineOpen' },
  keys = {
    { '<leader>o', '<cmd>OutlineOpen<CR>', desc = 'Outline [o]pen' },
    { '<leader>or', '<cmd>OutlineRefresh<CR>', desc = 'Outline [r]efresh' },
  },
  opts = {
    outline_window = {
      hide_cursor = true,
    },
    outline_items = {
      auto_update_events = {
        follow = { 'CursorMoved' },
        items = { 'InsertLeave', 'BufWritePost' },
      },
    },
    keymaps = {
      close = {},
    },
  },
}
