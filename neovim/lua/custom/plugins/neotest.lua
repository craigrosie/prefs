-- neotest
-- https://github.com/nvim-neotest/neotest
--

return {
  'nvim-neotest/neotest',
  event = 'VeryLazy',
  -- Optional dependency
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
    'fredrikaverpil/neotest-golang',
    'leoluz/nvim-dap-go', -- required by neotest-golang
  },
  opts = function()
    local neotest_golang = require('neotest-golang')
    local neotest_python = require('neotest-python')

    return {
      adapters = {
        neotest_golang({
          dap_go_enabled = true, -- use nvim-dap-go
        }),
        neotest_python({
          dap = { justMyCode = false },
          args = { '-vv' },
          pytest_discover_instances = false,
        }),
      },
      quickfix = { enabled = false },
    }
  end,
  keys = {
    { '<leader>tf', ":lua require('neotest').run.run({vim.fn.expand('%')})<cr>", desc = 'test [f]ile' },
    { '<leader>tn', ":lua require('neotest').run.run()<cr>", desc = 'test [n]earest' },
    { '<leader>ta', ":lua require('neotest').run.attach()<cr>", desc = '[a]ttach' },
    { '<leader>ts', ":lua require('neotest').run.stop()<cr>", desc = '[s]top' },
    { '<leader>td', ":lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = '[d]ebug' },
    { '<leader>to', ":lua require('neotest').output.open({enter = true})<cr>", desc = '[o]utput' },
    { '<leader>tp', ":lua require('neotest').output_panel.toggle({enter = true})<cr>", desc = 'output [p]anel' },
    { '<leader>tt', ":lua require('neotest').summary.toggle()<cr>", desc = 'summary [t]oggle' },
  },
}
