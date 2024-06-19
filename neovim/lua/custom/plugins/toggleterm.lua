return {
  'akinsho/toggleterm.nvim',
  event = 'VeryLazy',
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

    vim.api.nvim_set_keymap(
      'n',
      '<leader>qg',
      '<cmd>lua _lazygit_toggle()<CR>',
      { desc = 'Toggle lazygit', noremap = true, silent = true }
    )

    function _close_all_toggleterms()
      local terms = require('toggleterm.terminal')

      local terminals = terms.get_all()

      for _, term in pairs(terminals) do
        term:close()
      end
    end
    vim.api.nvim_set_keymap(
      'n',
      '<leader>qt',
      '<cmd>lua _close_all_toggleterms()<CR>',
      { desc = 'Close all toggleterms', noremap = true, silent = true }
    )

    return {
      direction = 'vertical',
      size = 120,
    }
  end,
}
