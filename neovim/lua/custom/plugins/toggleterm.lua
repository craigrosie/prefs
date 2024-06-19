return {
  'akinsho/toggleterm.nvim',
  event = 'VeryLazy',
  -- Optional dependency
  -- dependencies = {
  --   'nvim-neotest/nvim-nio',
  --   'nvim-lua/plenary.nvim',
  --   'nvim-treesitter/nvim-treesitter',
  --   'nvim-neotest/neotest-python',
  -- },
  opts = function()
    -- Enable navigation while in a toggleterm
    vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h')
    vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j')
    vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k')
    vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l')
    vim.keymap.set('t', '<C-e>', '<C-\\><C-n>')

    -- lazygit
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = 'lazygit',
      display_name = 'lazygit',
      direction = 'float',
      close_on_exit = true,
      hidden = true,
    })

    function _lazygit_toggle()
      lazygit:toggle()
    end

    vim.api.nvim_set_keymap('n', '<leader>qg', '<cmd>lua _lazygit_toggle()<CR>', { noremap = true, silent = true })

    return {
      direction = 'vertical',
      size = 120,
    }
  end,
  -- keys = {
  --   { '<leader>tf', ":lua require('neotest').run.run({vim.fn.expand('%')})<cr>", desc = 'test [f]ile' },
  --   { '<leader>tn', ":lua require('neotest').run.run()<cr>", desc = 'test [n]earest' },
  --   { '<leader>ta', ":lua require('neotest').run.attach()<cr>", desc = '[a]ttach' },
  --   { '<leader>ts', ":lua require('neotest').run.stop()<cr>", desc = '[s]top' },
  --   { '<leader>td', ":lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = '[d]ebug' },
  --   { '<leader>to', ":lua require('neotest').output.open({enter = true})<cr>", desc = '[o]utput' },
  --   { '<leader>tp', ":lua require('neotest').output_panel.toggle({enter = true})<cr>", desc = 'output [p]anel' },
  --   { '<leader>tt', ":lua require('neotest').summary.toggle()<cr>", desc = 'summary [t]oggle' },
  -- },
}
