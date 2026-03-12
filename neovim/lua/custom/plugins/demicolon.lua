return {
  'mawkler/demicolon.nvim',
  enabled = true,
  keys = { ';', ',', 't', 'f', 'T', 'F', ']', '[' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  opts = {
    -- Create default keymaps
    keymaps = {
      -- Create t/T/f/F key mappings
      horizontal_motions = true,
      -- Create ; and , key mappings. Set it to 'stateless', 'stateful', or false to
      -- not create any mappings. 'stateless' means that ;/, move right/left.
      -- 'stateful' means that ;/, will remember the direction of the original
      -- jump, and `,` inverts that direction (Neovim's default behaviour).
      repeat_motions = 'stateless',
    },
  },
}
