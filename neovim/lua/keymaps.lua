-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>qq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

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

-- Minimize split (set width to zero)
vim.keymap.set('n', '<leader>0', ':vertical resize 0<CR>', { desc = 'Minimize split width' })

-- indent while remaining in visual mode
vim.keymap.set('v', '<', '<gv', { desc = '< dedent' })
vim.keymap.set('v', '>', '>gv', { desc = '> indent' })

-- paste without overwriting register
vim.keymap.set('x', 'p', '"_dP', { desc = 'Paste without overwriting register' })

-- keep cursor centered
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous result' })
vim.keymap.set('n', '<C-o>', '<C-o>zz', { desc = 'Jump back' })
vim.keymap.set('n', '<C-i>', '<C-i>zz', { desc = 'Jump forward' })

vim.keymap.set(
  'n',
  '<C-w>t',
  ':tab split<cr>',
  { desc = 'Open current buffer in new tab', noremap = true, silent = true }
)

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

vim.keymap.set(
  { 'n' },
  '<leader>ci',
  ':!code-insiders .<CR>',
  { desc = 'Launch VS Code Insiders in the current directory' }
)

-- Split function arguments onto separate lines
local function split_args_to_newlines()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1 -- make 0-indexed for nvim_buf_set_lines
  col = col + 1 -- make 1-indexed for Lua string operations

  -- Scan backward from cursor to find the nearest un-closed '('
  local open_pos = nil
  local depth = 0
  for i = col, 1, -1 do
    local c = line:sub(i, i)
    if c == ')' then
      depth = depth + 1
    elseif c == '(' then
      if depth == 0 then
        open_pos = i
        break
      end
      depth = depth - 1
    end
  end
  -- Fallback: first '(' after cursor position
  if not open_pos then
    open_pos = line:find('(', col, true)
  end
  if not open_pos then
    return
  end

  -- Find the matching closing ')'
  depth = 0
  local close_pos = nil
  for i = open_pos, #line do
    local c = line:sub(i, i)
    if c == '(' then
      depth = depth + 1
    elseif c == ')' then
      depth = depth - 1
      if depth == 0 then
        close_pos = i
        break
      end
    end
  end
  if not close_pos then
    return
  end

  local before = line:sub(1, open_pos - 1)
  local args_str = line:sub(open_pos + 1, close_pos - 1)
  local after = line:sub(close_pos + 1)

  -- Use line's leading whitespace + one shiftwidth for arg indent
  local indent = before:match('^(%s*)')
  local sw = (vim.o.shiftwidth > 0) and vim.o.shiftwidth or vim.o.tabstop
  local arg_indent = indent .. string.rep(' ', sw)

  -- Parse top-level args, respecting nested parens/brackets/braces
  local args = {}
  local current = ''
  local d = 0
  for i = 1, #args_str do
    local c = args_str:sub(i, i)
    if c == '(' or c == '[' or c == '{' then
      d = d + 1
      current = current .. c
    elseif c == ')' or c == ']' or c == '}' then
      d = d - 1
      current = current .. c
    elseif c == ',' and d == 0 then
      local trimmed = current:match('^%s*(.-)%s*$')
      if trimmed ~= '' then
        table.insert(args, trimmed)
      end
      current = ''
    else
      current = current .. c
    end
  end
  local last = current:match('^%s*(.-)%s*$')
  if last ~= '' then
    table.insert(args, last)
  end

  if #args == 0 then
    return
  end

  -- Build replacement lines
  local new_lines = { before .. '(' }
  for _, arg in ipairs(args) do
    table.insert(new_lines, arg_indent .. arg .. ',')
  end
  table.insert(new_lines, indent .. ')' .. after)

  vim.api.nvim_buf_set_lines(0, row, row + 1, false, new_lines)
end

vim.keymap.set('n', '<leader>nl', split_args_to_newlines, { desc = '[N]ew [L]ines - split args onto separate lines' })

-- Open the GitHub page for the Neovim plugin under the cursor (owner/repo format)
local function open_plugin_github()
  -- Expand the WORD under the cursor (contiguous non-whitespace characters)
  local word = vim.fn.expand('<cWORD>')
  -- Strip any surrounding quotes, commas, or braces that may wrap the spec string
  word = word:match('[\'"]?([%w%-%.]+/[%w%-%.]+)[\'"]?') or word
  if not word:match('^[%w%-%.]+/[%w%-%.]+$') then
    vim.notify('No plugin (owner/repo) found under cursor', vim.log.levels.WARN)
    return
  end
  local url = 'https://github.com/' .. word
  vim.ui.open(url)
end

vim.keymap.set('n', '<leader>gp', open_plugin_github, { desc = 'Open [G]itHub [P]lugin page' })

-- vim: ts=2 sts=2 sw=2 et
