-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      {
        'nvim-telescope/telescope-live-grep-args.nvim',
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = '^1.0.0',
      },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      local actions = require('telescope.actions')
      local telescope = require('telescope')

      telescope.setup({
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        defaults = {
          mappings = {
            i = {
              ['<c-a>'] = actions.toggle_all,
              ['<c-f>'] = actions.send_selected_to_qflist + actions.open_qflist,
              ['<c-q>'] = false,
              ['<c-\\>'] = actions.to_fuzzy_refine,
            },
            n = {
              ['<c-a>'] = actions.toggle_all,
              ['<c-f>'] = actions.send_selected_to_qflist + actions.open_qflist,
              ['<c-q>'] = false,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          lsp_document_symbols = {
            symbol_width = 80,
            show_line = true,
          },
          lsp_dynamic_workspace_symbols = {
            fname_width = 80,
            symbol_width = 80,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          smart_open = {
            match_algorithm = 'fzf',
            disable_devicons = false,
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
      pcall(telescope.load_extension, 'live_grep_args')

      -- See `:help telescope.builtin`
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>si', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sf', function()
        builtin.find_files({
          no_ignore = true,
          no_ignore_parent = true,
          file_ignore_patterns = { 'node_modules/', '.git/', 'dist/', 'build/', '.next/' },
        })
      end, { desc = '[S]earch []' })
      vim.keymap.set('n', '<leader>sb', function()
        builtin.buffers({ only_cwd = true, sort_mru = true })
      end, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sc', builtin.grep_string, { desc = '[S]earch [C]urrent Word' })
      vim.keymap.set('n', '<leader>st', function()
        builtin.grep_string({ word_match = '-w', only_sort_text = true, search = '' })
      end, { desc = '[S]earch Fuzzy [T]ext' })
      vim.keymap.set('n', '<leader>s_', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set(
        'n',
        '<leader>sg',
        telescope.extensions.live_grep_args.live_grep_args,
        { desc = '[S]earch by [G]rep' }
      )
      vim.keymap.set('n', '<leader>sl', builtin.lsp_document_symbols, { desc = '[S]earch by [l]sp document symbols' })
      vim.keymap.set(
        'n',
        '<leader>sw',
        builtin.lsp_dynamic_workspace_symbols,
        { desc = '[S]earch by lsp workspace symbols' }
      )
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', function()
        builtin.oldfiles({ only_cwd = true })
      end, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>s:', builtin.command_history, { desc = '[S]earch [:]Command History' })
      vim.keymap.set('n', '<leader>s/', builtin.search_history, { desc = '[S]earch [/]Search History' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          -- winblend = 10,
          previewer = false,
          layout_config = {
            width = 0.25,
            height = 0.3,
          },
        }))
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      -- vim.keymap.set('n', '<leader>s/', function()
      --   builtin.live_grep({
      --     grep_open_files = true,
      --     prompt_title = 'Live Grep in Open Files',
      --   })
      -- end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
