local helpers = require('helpers')

return {
  'pwntester/octo.nvim',
  enabled = helpers.is_plugin_enabled('NVIM_ENABLE_OCTO'),
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
