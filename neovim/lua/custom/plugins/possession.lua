return {
  'jedrzejboczar/possession.nvim',
  -- NOTE: Don't enable lazy loading or autoload doesn't work
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    -- silent = false,
    -- load_silent = false,
    -- debug = true,
    -- logfile = true,
    autosave = {
      current = true,
      cwd = true,
    },
    -- NOTE: Disable cwd autoload because it breaks using nvim to write commit messages
    autoload = false,
  },
  keys = {
    { '<leader>pl', ':PossessionLoadCwd<cr>', desc = '[P]ossession[L]oadCwd' },
  },
}
