return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  init = function()
    -- Disable entire built-in ftplugin mappings to avoid conflicts.
    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
    vim.g.no_plugin_maps = true

    -- Or, disable per filetype (add as you like)
    -- vim.g.no_python_maps = true
    -- vim.g.no_ruby_maps = true
    -- vim.g.no_rust_maps = true
    -- vim.g.no_go_maps = true
  end,
  config = function()
    -- move
    vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
      require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
      require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
      require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
      require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
    end)

    -- select
    vim.keymap.set({ 'x', 'o' }, 'am', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'im', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
    end)

    -- swap
    vim.keymap.set('n', '<leader>np', function()
      require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
    end)
    vim.keymap.set('n', '<leader>pp', function()
      require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')
    end)

    return {
      move = {
        set_jumps = true, -- whether to set jumps in the jumplist
      },
      select = {
        lookahead = true,
      },
    }
  end,
}
