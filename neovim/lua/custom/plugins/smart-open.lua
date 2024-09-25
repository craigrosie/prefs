return {
  'danielfalk/smart-open.nvim',
  branch = '0.2.x',
  config = function()
    require('telescope').load_extension('smart_open')
  end,
  dependencies = {
    'kkharji/sqlite.lua',
    -- Only required if using match_algorithm fzf
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  keys = {
    {
      '<leader><leader>',
      function()
        require('telescope').extensions.smart_open.smart_open({
          cwd_only = true,
        })
      end,
      { noremap = true, silent = true },
      desc = 'Telescope smart_open',
    },
  },
}
