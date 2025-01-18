return {
  'DNLHC/glance.nvim',
  event = 'VeryLazy',
  -- Optional dependency
  opts = function()
    return {
      height = 25,
      border = {
        enable = true, -- Show window borders. Only horizontal borders allowed
        top_char = '―',
        bottom_char = '―',
      },
      theme = { -- This feature might not work properly in nvim-0.7.2
        enable = true, -- Will generate colors for the plugin based on your current colorscheme
        mode = 'darken', -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
      },
      detached = true,
    }
  end,
  keys = {
    { '<leader>gr', ':Glance references<cr>', desc = '[g]lance [r]eferences' },
    { '<leader>gd', ':Glance definitions<cr>', desc = '[g]lance [d]definitions' },
    { '<leader>gt', ':Glance type_definitions<cr>', desc = '[g]lance [t]ype_definitions' },
    { '<leader>gi', ':Glance implementations<cr>', desc = '[g]lance [i]mplementations' },
  },
}
