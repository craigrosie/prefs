return {
  'karb94/neoscroll.nvim',
  config = function()
    require('neoscroll').setup({
      mappings = {
        '<C-u>',
        '<C-d>',
        '<C-b>',
        '<C-y>',
        'zt',
        'zz',
        'zb',
      },
    })
  end,
}
