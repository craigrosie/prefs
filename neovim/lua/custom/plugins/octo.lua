return {
  'pwntester/octo.nvim',
  enabled = vim.g.is_work_env_set,
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    ssh_aliases = { ['github.com-craigrosie'] = 'github.com' },
  },
}
