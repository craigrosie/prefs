-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    require('mason-nvim-dap').setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = false,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {
        function(config)
          -- all sources with no handler get passed here

          -- Keep original functionality
          require('mason-nvim-dap').default_setup(config)
        end,
        python = function(config)
          config.adapters = {
            type = 'executable',
            -- TODO: move this to variable
            command = vim.fn.expand('~/.pyenv/versions/.neovenv-3.11.4/bin/python3'),
            args = {
              '-m',
              'debugpy.adapter',
            },
          }

          config.configurations = {
            {
              name = 'Docker',
              type = 'python',
              request = 'attach',

              mode = 'remote',
              cwd = vim.fn.getcwd(),
              -- justMyCode = false,
              connect = { host = '0.0.0.0', port = 9999 },
              pathMappings = { { localRoot = vim.fn.getcwd(), remoteRoot = '/app' } },
            },
            {
              name = 'Python',
              type = 'python',
              request = 'launch',

              program = '${file}',
              justMyCode = false,
              pythonPath = function()
                return os.getenv('VIRTUAL_ENV') .. '/bin/python'
              end,
            },
            {
              name = 'Django',
              type = 'python',
              request = 'launch',

              program = '${workspaceFolder}/manage.py',
              justMyCode = false,
              django = true,
              args = { 'start', '--frontend=none', '--noreload' },
              console = 'integratedTerminal',
              pythonPath = function()
                return os.getenv('VIRTUAL_ENV') .. '/bin/python'
              end,
            },
          }

          require('mason-nvim-dap').default_setup(config) -- don't forget this!
        end,
      },

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'python',
      },
    })

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/[c]ontinue' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step [i]nto' })
    vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step [o]ver' })
    vim.keymap.set('n', '<leader>du', dap.step_out, { desc = 'Debug: Step o[u]t' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle [b]reakpoint' })
    vim.keymap.set('n', '<leader>d[', dap.up, { desc = 'Debug: up [' })
    vim.keymap.set('n', '<leader>d]', dap.down, { desc = 'Debug: down ]' })
    vim.keymap.set('n', '<leader>dr', dap.run_to_cursor, { desc = 'Debug: [r]un to cursor' })
    vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Debug: [t]erminate' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input('[B]reakpoint condition: '))
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup({
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '➜' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '',
          step_over = '',
          step_out = '',
          step_back = '',
          run_last = '',
          terminate = '⏹',
          disconnect = '',
        },
      },
      expand_lines = true,
      layouts = {
        {
          elements = {
            -- Elements can be strings or table with id and size keys.
            { id = 'scopes', size = 0.50 },
            { id = 'watches', size = 0.30 },
            { id = 'breakpoints', size = 0.10 },
            { id = 'stacks', size = 0.10 },
          },
          size = 0.20,
          position = 'left',
        },
        { elements = { 'repl', 'console' }, size = 0.25, position = 'bottom' },
      },
    })

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<leader>dd', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '', linehl = '', numhl = '' })
  end,
}
