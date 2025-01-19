return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    -- Disable pretty much everything apart from the cmdline
    messages = {
      enabled = false,
    },
    notify = {
      enabled = false,
    },
    lsp = {
      progress = {
        enabled = false,
      },
      hover = {
        enabled = false,
      },
      signature = {
        enabled = false,
      },
      messages = {
        enabled = false,
      },
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
  },
}
