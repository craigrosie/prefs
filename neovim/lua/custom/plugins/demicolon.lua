return {
  'mawkler/demicolon.nvim',
  enabled = true,
  keys = { ';', ',', 't', 'f', 'T', 'F', ']', '[', ']d', '[d' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  opts = {
    integrations = {
      gitsigns = {
        enabled = true,
      },
      neotest = {
        enabled = true,
      },
      vimtex = {
        enabled = false,
      },
    },
  },
}
