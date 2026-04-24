return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    lazygit = {
      configure = true,
      config = {
        os = {
          edit = 'nvim --server "$NVIM" --remote {{filename}}',
          editAtLine = 'nvim --server "$NVIM" --remote {{filename}}; nvim --server "$NVIM" --remote-send ":{{line}}<CR>"',
          editAtLineAndWait = 'nvim --server "$NVIM" --remote-wait {{filename}}; nvim --server "$NVIM" --remote-send ":{{line}}<CR>"',
          editInTerminal = false,
        },
      },
    },
  },
  keys = {
    {
      '<leader>qg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Toggle lazygit',
    },
  },
}
