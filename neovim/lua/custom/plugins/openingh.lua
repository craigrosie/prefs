return {
  'Almo7aya/openingh.nvim',
  event = 'VeryLazy',
  -- Optional dependency
  opts = {},
  keys = {
    { '<leader>gh', ':OpenInGHFile<cr>', mode = { 'n', 'v' }, desc = 'Open in [g]it[h]ub' },
  },
}
