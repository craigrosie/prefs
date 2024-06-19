return {
  'ryanmsnyder/toggleterm-manager.nvim',
  event = 'VeryLazy',
  dependencies = {
    'akinsho/nvim-toggleterm.lua',
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local toggleterm_manager = require('toggleterm-manager')
    local actions = toggleterm_manager.actions

    toggleterm_manager.setup({
      mappings = {
        i = {
          ['<C-t>'] = { action = actions.create_and_name_term, exit_on_action = true },
          ['<C-d>'] = { action = actions.delete_term, exit_on_action = false },
          ['<CR>'] = { action = actions.toggle_term, exit_on_action = true },
        },
        n = {
          ['<C-t>'] = { action = actions.create_and_name_term, exit_on_action = true },
          ['<C-d>'] = { action = actions.delete_term, exit_on_action = false },
          ['<C-r>'] = { action = actions.rename_term, exit_on_action = false },
          ['<CR>'] = { action = actions.toggle_term, exit_on_action = true },
        },
      },
    })
  end,
  keys = {
    { '<leader>qi', ':Telescope toggleterm_manager<cr>', desc = 'toggleterm manager' },
  },
}
