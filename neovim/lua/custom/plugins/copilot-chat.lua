local helpers = require('helpers')

return {
  'CopilotC-Nvim/CopilotChat.nvim',
  enabled = helpers.is_plugin_enabled('NVIM_ENABLE_COPILOT_CHAT'),
  event = 'VeryLazy',
  dependencies = {
    'zbirenbaum/copilot.lua',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local copilot_prompts = {
      -- Code related prompts
      Explain = 'Please explain how the following code works.',
      Review = 'Please review the following code and provide suggestions for improvement.',
      Tests = 'Please explain how the selected code works, then generate unit tests for it.',
      Refactor = 'Please refactor the following code to improve its clarity and readability.',
      FixCode = 'Please fix the following code to make it work as intended.',
      FixError = 'Please explain the error in the following text and provide a solution.',
      BetterNamings = 'Please provide better names for the following variables and functions.',
      Documentation = 'Please provide documentation for the following code.',
      -- Text related prompts
      Summarize = 'Please summarize the following text.',
      Spelling = 'Please correct any grammar and spelling errors in the following text.',
      Wording = 'Please improve the grammar and wording of the following text.',
      Concise = 'Please rewrite the following text to make it more concise.',
    }

    local chat = require('CopilotChat')
    local select = require('CopilotChat.select')

    chat.setup({
      prompts = copilot_prompts,
      auto_insert_mode = true,
      auto_follow_cursor = false,
      show_help = false,
      -- Registers copilot-chat source and enables it for copilot-chat filetype (so copilot chat window)
      chat_autocomplete = true,
      window = {
        layout = 'horizontal',
        relative = 'editor',
        width = 1,
        height = 0.4,
      },
      question_header = '# Me',
      mappings = {
        complete = {
          insert = '<Tab>',
        },
        close = {
          normal = '<leader>gx',
          insert = '<C-9>',
        },
        reset = {
          normal = 'gx',
          insert = '',
        },
        submit_prompt = {
          normal = '<C-s',
          insert = '<C-s>',
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>',
        },
        yank_diff = {
          normal = 'gy',
        },
        show_diff = {
          normal = 'gd',
        },
        show_info = {
          normal = 'gp',
        },
        show_context = {
          normal = 'gs',
        },
      },
    })

    vim.api.nvim_create_user_command('CopilotChatSplit', function(args)
      local _, end_line = unpack(vim.fn.getpos("'>"))
      chat.ask(args.args, {
        selection = select.visual,
        window = { layout = 'horizontal', relative = 'editor', width = 1, height = 0.4 },
      })
    end, { nargs = '*', range = true })
  end,
  keys = {
    { '<leader>ac', ':CopilotChatToggle<cr>', mode = { 'n', 'v' }, desc = '[C]opilot [c]hat toggle window' },
    { '<leader>ad', ':CopilotChatDocs<cr>', mode = { 'n', 'v' }, desc = '[C]opilot chat [d]ocs' },
    { '<leader>ae', ':CopilotChatExplain<cr>', mode = { 'n', 'v' }, desc = '[C]opilot chat [e]xplain' },
    { '<leader>af', ':CopilotChatFix<cr>', mode = { 'n', 'v' }, desc = '[C]opilot chat [f]ix' },
    { '<leader>ai', ':CopilotChatFixDiagnostic<cr>', mode = { 'n', 'v' }, desc = '[C]opilot chat fix d[i]agnostic' },
    { '<leader>al', ':CopilotChatSplit<cr>', mode = { 'n', 'v' }, desc = '[C]opilot chat sp[l]it' },
    { '<leader>ao', ':CopilotChatOptimize<cr>', mode = { 'n', 'v' }, desc = '[C]opilot chat [o]ptimize' },
    { '<leader>ar', ':CopilotChatRefactor<cr>', mode = { 'n', 'v' }, desc = '[C]opilot chat [r]efactor' },
    { '<leader>at', ':CopilotChatTests<cr>', mode = { 'n', 'v' }, desc = '[C]opilot chat [t]ests' },
    -- Show help actions with telescope - doesn't seem to work
    {
      '<leader>ah',
      function()
        local actions = require('CopilotChat.actions')
        require('CopilotChat.integrations.telescope').pick(actions.help_actions())
      end,
      desc = '[C]opilot chat [h]elp actions',
    },
    -- Show prompts actions with telescope
    {
      mode = { 'n', 'v' },
      '<leader>am',
      function()
        local actions = require('CopilotChat.actions')
        require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
      end,
      desc = 'Copilot chat [p]rompt actions',
    },
  },
}
