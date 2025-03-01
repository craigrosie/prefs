local code_wrap_enabled = false

local function toggle_code_wrap()
  if code_wrap_enabled then
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = false
    vim.opt_local.breakindent = false
    vim.opt_local.showbreak = ''
  else
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = '↪ '
  end
  code_wrap_enabled = not code_wrap_enabled
end

vim.api.nvim_create_user_command('ToggleCodeWrap', toggle_code_wrap, {})
vim.keymap.set(
  'n',
  '<leader>w',
  ':ToggleCodeWrap<CR>',
  { desc = 'Toggle code [w]rapping', noremap = true, silent = true }
)
