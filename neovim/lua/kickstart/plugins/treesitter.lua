return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'LiadOz/nvim-dap-repl-highlights',
      'nvim-treesitter/nvim-treesitter-context',
    },
    build = ':TSUpdate',
    opts = function()
      -- Must be setup first otherwise `dap_repl` will not be available
      -- to `ensure_installed`
      require('nvim-dap-repl-highlights').setup()

      require('treesitter-context').setup({
        multiline_threshold = 5,
      })

      return {
        ensure_installed = {
          'bash',
          'c',
          'dap_repl',
          'diff',
          'dockerfile',
          'go',
          'gomod',
          'gowork',
          'gosum',
          'git_config',
          'gitcommit',
          'gitignore',
          'html',
          'java',
          'javascript',
          'json',
          'kotlin',
          'lua',
          'luadoc',
          'make',
          'markdown',
          'markdown_inline',
          'python',
          'regex',
          'styled',
          'terraform',
          'toml',
          'tsx',
          'typescript',
          'vim',
          'vimdoc',
          'yaml',
        },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
        textobjects = {
          select = {
            enable = true,
            -- automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- ASSIGNMENT
              ['a='] = { query = '@assignment.outer', desc = 'Select outer part of assignment' },
              ['i='] = { query = '@assignment.inner', desc = 'Select inner part of assignment' },
              ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of assignment' },
              ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of assignment' },
              -- PARAMETER
              ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of parameter/argument' },
              ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of parameter/argument' },
              -- CONDITIONAL
              ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
              ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },
              -- LOOP
              ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
              ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },
              -- FUNCTION CALL
              ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
              ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },
              -- FUNCTION
              ['am'] = { query = '@function.outer', desc = 'Select outer part of a function definition' },
              ['im'] = { query = '@function.inner', desc = 'Select inner part of a function definition' },
              -- CLASS
              ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
              ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              -- swap parameter with next
              ['<leader>na'] = '@parameter.inner',
              -- swap function with next
              ['<leader>nm'] = '@function.outer',
            },
            swap_previous = {
              -- swap parameter with next
              ['<leader>pa'] = '@parameter.inner',
              -- swap function with next
              ['<leader>pm'] = '@function.outer',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']f'] = { query = '@call.outer', desc = 'Next function call start' },
              [']m'] = { query = '@function.outer', desc = 'Next function definition start' },
              [']c'] = { query = '@class.outer', desc = 'Next class start' },
              [']i'] = { query = '@conditional.outer', desc = 'Next conditional start' },
              [']l'] = { query = '@loop.outer', desc = 'Next loop start' },

              [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
              [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
            },
            goto_next_end = {
              [']F'] = { query = '@call.outer', desc = 'Next function call end' },
              [']M'] = { query = '@function.outer', desc = 'Next function definition end' },
              [']C'] = { query = '@class.outer', desc = 'Next class end' },
              [']I'] = { query = '@conditional.outer', desc = 'Next conditional end' },
              [']L'] = { query = '@loop.outer', desc = 'Next loop end' },
            },
            goto_previous_start = {
              ['[f'] = { query = '@call.outer', desc = 'Previous function call start' },
              ['[m'] = { query = '@function.outer', desc = 'Previous function definition start' },
              ['[c'] = { query = '@class.outer', desc = 'Previous class start' },
              ['[i'] = { query = '@conditional.outer', desc = 'Previous conditional start' },
              ['[l'] = { query = '@loop.outer', desc = 'Previous loop start' },

              ['[s'] = { query = '@scope', query_group = 'locals', desc = 'Previous scope' },
              ['[z'] = { query = '@fold', query_group = 'folds', desc = 'Previous fold' },
            },
            goto_previous_end = {
              ['[F'] = { query = '@call.outer', desc = 'Previous function call end' },
              ['[M'] = { query = '@function.outer', desc = 'Previous function definition end' },
              ['[C'] = { query = '@class.outer', desc = 'Previous class end' },
              ['[I'] = { query = '@conditional.outer', desc = 'Previous conditional end' },
              ['[L'] = { query = '@loop.outer', desc = 'Previous loop end' },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
