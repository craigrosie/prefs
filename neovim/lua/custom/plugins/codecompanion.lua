local utils = require('utils')

return {
  'olimorris/codecompanion.nvim',
  enabled = utils.is_plugin_enabled('NVIM_ENABLE_CODE_COMPANION'),
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
    'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
    { 'stevearc/dressing.nvim', opts = {} }, -- Optional: Improves the default Neovim UI
  },
  config = function()
    require('codecompanion').setup({
      strategies = {
        chat = {
          adapter = 'copilot',
          keymaps = {
            close = {
              n = '<C-c>',
              i = '<C-c>',
            },
            stop = {
              modes = {
                n = '<C-x>',
              },
            },
          },
        },
        inline = {
          adapter = 'copilot',
          keymaps = {
            accept_change = {
              modes = {
                n = '<C-y>',
              },
            },
          },
        },
        agent = {
          adapter = 'copilot',
        },
      },
      display = {
        chat = {
          window = {
            layout = 'horizontal',
            width = 1,
            height = 0.4,
          },
        },
      },
      pre_defined_prompts = {
        -- Have to set mappings for these because disabling them (setting to nil) doesn't seem to work
        ['Custom Prompt'] = {
          opts = {
            mapping = ';custom',
          },
        },
        ['Explain'] = {
          opts = {
            mapping = ';explain',
          },
        },
        ['Unit Tests'] = {
          opts = {
            mapping = ';test',
          },
        },
        ['Fix code'] = {
          opts = {
            mapping = ';fix',
          },
        },
        ['Buffer selection'] = {
          opts = {
            mapping = ';buffer',
          },
        },
        ['Explain LSP Diagnostics'] = {
          opts = {
            mapping = ';diag',
          },
        },
        ['Generate a Commit Message'] = {
          strategy = 'chat',
          description = 'Generate a commit message',
          opts = {
            index = 9,
            default_prompt = true,
            mapping = ';commit',
            slash_cmd = 'commit',
            auto_submit = true,
          },
          prompts = {
            {
              role = 'user',
              content = function()
                return string.format(
                  [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

```diff
%s
```
]],
                  vim.fn.system('git diff --staged')
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ['Review this code'] = {
          strategy = 'chat',
          description = 'Review this code and suggest improvements',
          opts = {
            index = 10,
            default_prompt = false,
            mapping = ';review',
            slash_cmd = 'review',
            auto_submit = true,
          },
          prompts = {
            {
              role = 'user',
              content = function(context)
                local code = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                return string.format(
                  [[I want you to act as a senior %s developer. I want you to review the selected code, then suggest improvements and provide feedback. Please consider the following points:

1. Only use idiomatic code and best practices for the language.
2. Suggest improvements to the code.
3. Favour deep modules/functions, based on principles of "A Philosophy of Software Design" by John Ousterhout.
4. Suggest better names for variables, functions or classes, if appropriate.
5. Suggest better abstractions, if appropriate.
6. Suggest better error handling, if appropriate.
7. Only make suggestions if you are confident that they actually improve the code. Don't suggest changes just for the sake of it.

```%s
%s
```
]],
                  context.filetype,
                  context.filetype,
                  code
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
    })
    vim.keymap.set('v', '<leader>cl', "<cmd>'<,'>CodeCompanion<cr>", { desc = '[c]odecompanion in[l]ine prompt' })
    vim.keymap.set('v', '<leader>cf', '<cmd>CodeCompanion /lsp<cr>', { desc = '[c]odecompanion [f]ix diagnostics' })
    vim.keymap.set('v', '<leader>ca', '<cmd>CodeCompanionAdd<cr>', { desc = '[c]odecompanion add selection to chat' })
    vim.keymap.set(
      { 'n', 'v' },
      '<leader>cc',
      '<cmd>CodeCompanionToggle<cr>',
      { desc = '[c]odecompanion toggle [c]hat' }
    )
    vim.keymap.set(
      { 'v', 'n' },
      '<leader>cm',
      '<cmd>CodeCompanionActions<cr>',
      { desc = '[c]odecompanion actions [m]enu' }
    )
  end,
}
