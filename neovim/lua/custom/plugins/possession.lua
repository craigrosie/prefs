return {
  'jedrzejboczar/possession.nvim',
  -- Don't enable lazy loading or autoload doesn't work
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
    autoload = {
      cwd = true,
    },
  },
  keys = {},
}
