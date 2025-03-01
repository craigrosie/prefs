local helpers = require('helpers')

return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
      'f3fora/cmp-spell',
      'onsails/lspkind.nvim',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require('cmp')
      local lspkind = require('lspkind')
      local luasnip = require('luasnip')
      luasnip.config.setup({})

      local sources = {
        { name = 'luasnip' },
        { name = 'lazydev' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'path' },
        { name = 'buffer', keyword_length = 2 },
      }
      local comparators = {
        -- Below is the default comparator list and order for nvim-cmp
        cmp.config.compare.offset,
        -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      }
      -- Conditionally add copilot stuff
      if helpers.is_plugin_enabled('NVIM_ENABLE_COPILOT_CHAT') then
        table.insert(sources, 2, { name = 'copilot' })
        table.insert(sources, 1, { require('copilot_cmp.comparators').prioritize })
      end

      -- Recommended by copilot-cmp
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match('^%s*$') == nil
      end
      cmp.setup({
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- recommended configuration for <Tab> people:
        mapping = {
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end, {
            'i',
            's', --[[ "c" (to enable the mapping in command mode) ]]
          }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, {
            'i',
            's', --[[ "c" (to enable the mapping in command mode) ]]
          }),
          ['<CR>'] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              elseif luasnip.expandable() then
                luasnip.expand()
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
          }),
        },
        completion = { completeopt = 'menu,menuone,noselect' },

        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            symbol_map = { Copilot = '' },

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
              return vim_item
            end,
          }),
        },

        sources = sources,

        sorting = {
          priority_weight = 2,
          comparators = comparators,
        },
        -- might conflict with copilot.vim's preview
        -- definitely clashes with emmet_language_server
        -- experimental = { ghost_text = true },
      })
      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        -- NOTE: this breaks autocomplete after the first completion
        -- in commandline mode, I have no idea why
        -- mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
