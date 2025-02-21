-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Adjust viewports to the same size
vim.keymap.set('n', '<leader>=', '<C-w>=')

-- Adjust split size
vim.keymap.set('n', '<leader>]', ':vertical resize +10<CR>')
vim.keymap.set('n', '<leader>[', ':vertical resize -10<CR>')

-- indent while remaining in visual mode
vim.keymap.set('v', '<', '<gv', { desc = '< dedent' })
vim.keymap.set('v', '>', '>gv', { desc = '> indent' })

-- keep cursor centered
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll downwards' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll upwards' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous result' })
vim.keymap.set('n', '<C-o>', '<C-o>zz', { desc = 'Jump back' })
vim.keymap.set('n', '<C-i>', '<C-i>zz', { desc = 'Jump forward' })

vim.keymap.set('n', '<C-w>t', ':tab split<cr>', { desc = 'Open current buffer in new tab' })

vim.keymap.set('n', 'j', 'gj', { desc = 'Move linewise even on wrapped lines' })
vim.keymap.set('n', 'k', 'gk', { desc = 'Move linewise even on wrapped lines' })

local function toggle_diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

vim.keymap.set(
  'n',
  '<leader>xd',
  toggle_diagnostics,
  { noremap = true, silent = true, desc = 'Toggle vim diagnostics' }
)

-- vim: ts=2 sts=2 sw=2 et
