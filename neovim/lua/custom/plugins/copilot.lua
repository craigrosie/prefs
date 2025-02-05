local helpers = require('helpers')

return {
  'zbirenbaum/copilot.lua',
  enabled = helpers.is_plugin_enabled('NVIM_ENABLE_COPILOT'),
  event = 'InsertEnter',
  dependencies = {
    'zbirenbaum/copilot-cmp',
  },
  config = function()
    local copilot = require('copilot')
    copilot.setup({
      panel = {
        -- Recommended to be disabled for copilot_cmp
        enabled = false,
        auto_refresh = false,
        keymap = { jump_prev = '[[', jump_next = ']]', accept = '<leader>a', refresh = 'gr', open = '<leader>cp' },
        layout = {
          position = 'bottom', -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        -- Recommended to be disabled for copilot_cmp
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = '<c-t>',
          accept_word = false,
          accept_line = false,
          next = '<c-n>',
          prev = '<c-p>',
          dismiss = '<C-]>',
        },
      },
    })

    require('copilot_cmp').setup({})
  end,
  keys = {},
}
