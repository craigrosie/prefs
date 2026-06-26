return {
  'andrewferrier/wrapping.nvim',
  event = 'VeryLazy',
  config = function()
    require('wrapping').setup({
      softener = { markdown = true }, -- Always use soft (visual) wrap for markdown
    })
  end,
}
