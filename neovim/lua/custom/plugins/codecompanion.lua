local utils = require('utils')

local format_lines = function(prompt_lines, ...)
  local arguments = { ... }

  -- Ensure that all empty arguments are replaced with '%s', since that allows
  -- us to sanitize them.
  for idx, argument in ipairs(arguments) do
    if argument == '' then
      arguments[idx] = '%s'
    end
  end

  local prompt = table.concat(prompt_lines, '\n')

  if #arguments > 0 then
    prompt = prompt:format(unpack(arguments))
  end

  -- Remove any left over '%s', including the newline, from the prompt.
  return prompt:gsub('%%s\n', '')
end

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
      prompt_library = {
        -- Have to set mappings for these because disabling them (setting to nil) doesn't seem to work
        ['Custom Prompt'] = {
          opts = {
            mapping = false,
          },
        },
        ['Explain'] = {
          opts = {
            mapping = false,
          },
        },
        ['Unit Tests'] = {
          opts = {
            mapping = false,
          },
        },
        ['Fix code'] = {
          opts = {
            mapping = false,
          },
        },
        ['Buffer selection'] = {
          opts = {
            mapping = false,
          },
        },
        ['Explain LSP Diagnostics'] = {
          opts = {
            mapping = false,
          },
        },
        ['Generate a Commit Message'] = {
          opts = {
            mapping = false,
            slash_cmd = false,
          },
          prompts = {
            {
              role = 'user',
              content = function()
                -- return string.format(
                return format_lines({
                  'You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:',
                  '',
                  '```diff',
                  '%s',
                  '```',
                  ']],',
                }, vim.fn.system('git diff --staged'))
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        -- Custom prompts
        ['Review this code'] = {
          strategy = 'chat',
          description = 'Review this code and suggest improvements',
          opts = {
            index = 10,
            default_prompt = false,
            auto_submit = true,
          },
          prompts = {
            {
              role = 'user',
              content = function(context)
                local code = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                return format_lines({
                  'I want you to act as a senior %s developer. I want you to review the selected code, then suggest improvements and provide feedback. Please consider the following points:',
                  '',
                  '1. Only use idiomatic code and best practices for the language.',
                  '2. Suggest improvements to the code.',
                  '3. Favour deep modules/functions, based on principles of "A Philosophy of Software Design" by John Ousterhout.',
                  '4. Suggest better names for variables, functions or classes, if appropriate.',
                  '5. Suggest better abstractions, if appropriate.',
                  '6. Suggest better error handling, if appropriate.',
                  "7. Only make suggestions if you are confident that they actually improve the code. Don't suggest changes just for the sake of it.",
                  '',
                  '```%s',
                  '%s',
                  '```',
                }, context.filetype, context.filetype, code)
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ['Review PR code'] = {
          strategy = 'chat',
          description = 'Review PR code',
          opts = {
            index = 11,
            default_prompt = true,
            auto_submit = true,
          },
          prompts = {
            {
              role = 'user',
              content = function()
                return format_lines({
                  'I want you to act as a senior developer. I want you to review the selected code as if you were reviewing a pull request, then suggest improvements and provide feedback. Please consider the following points:',
                  '',
                  '1. Only use idiomatic code and best practices for the language.',
                  '2. Suggest improvements to the code.',
                  '3. Favour deep modules/functions, based on principles of "A Philosophy of Software Design" by John Ousterhout.',
                  '4. Suggest better names for variables, functions, interfaces or classes, if appropriate.',
                  '5. Suggest better abstractions, if appropriate.',
                  '6. Suggest better error handling, if appropriate.',
                  '7. Look out for typos or spelling mistakes.',
                  "8. Only make suggestions if you are confident that they actually improve the code. Don't suggest changes just for the sake of it.",
                  '',
                  '```diff',
                  '%s',
                  '```',
                }, vim.fn.system('git diff origin/main...HEAD'))
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ['PR Description'] = {
          strategy = 'chat',
          description = 'Generate a PR description',
          opts = {
            index = 12,
            default_prompt = true,
            auto_submit = true,
          },
          prompts = {
            {
              role = 'user',
              content = function()
                return format_lines({
                  'I want you to act as a senior developer. I want you to generate a pull request description for the changes you have made. Please consider the following points:',
                  '',
                  'Your task is to generate a very concise and structured pull request description based on the provided diffs. It must be easy to parse for reviewers.',
                  'The description should always include:',
                  '- A summary of the changes under a ### Summary heading.',
                  '- A bulleted list of the main changes under a ### Key Changes heading.',
                  'Avoid redundant information.',
                  '',
                  '```diff',
                  '%s',
                  '```',
                }, vim.fn.system('git diff origin/main...HEAD'))
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
    vim.keymap.set(
      'v',
      '<leader>ca',
      '<cmd>CodeCompanionChat Add<cr>',
      { desc = '[c]odecompanion add selection to chat' }
    )
    vim.keymap.set(
      { 'n', 'v' },
      '<leader>cc',
      '<cmd>CodeCompanionChat Toggle<cr>',
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
