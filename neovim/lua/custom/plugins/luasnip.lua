return {
  'L3MON4D3/LuaSnip',
  -- follow latest release.
  version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = 'make install_jsregexp',
  config = function()
    local ls = require('luasnip')
    local types = require('luasnip.util.types')
    local loaders = require('luasnip.loaders')

    vim.keymap.set({ 'i' }, '<C-e>', function()
      ls.expand()
    end, { silent = true })
    vim.keymap.set({ 'i', 's' }, '<C-j>', function()
      ls.jump(1)
    end, { silent = true })
    vim.keymap.set({ 'i', 's' }, '<C-k>', function()
      ls.jump(-1)
    end, { silent = true })

    vim.keymap.set({ 'i', 's' }, '<C-l>', function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true })
    vim.keymap.set({ 'n' }, '<leader>u', function()
      loaders.edit_snippet_files({
        edit = function(fn)
          vim.cmd('vsplit ' .. fn)
          vim.bo.filetype = 'lua'
        end,
      })
    end, { silent = true })

    require('luasnip.loaders.from_lua').load({ paths = './lua/custom/snippets' })

    ls.config.set_config({
      history = true, -- Remember last snippet
      store_selection_keys = '<C-e>', -- Keymap for storing visual selection
      updateevents = 'TextChanged,TextChangedI', -- Update dynamic snippets as you type
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { '<-', 'choice' } },
          },
        },
      },
    })
  end,
}
