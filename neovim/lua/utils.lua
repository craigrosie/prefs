local function get_code_reference()
  local api = vim.api
  local ts_utils = require('nvim-treesitter.ts_utils')
  local path = require('plenary.path')

  -- Get the relative file path from the project root
  local file = vim.fn.expand('%:p')
  local root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local rel_path = path:new(file):make_relative(root)

  -- Get the current line number and line content
  local line_num = api.nvim_win_get_cursor(0)[1]
  local line_content = api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]

  -- Get the enclosing function name
  local node = ts_utils.get_node_at_cursor()
  local func_name = '?'

  while node do
    if
      node:type() == 'function_declaration'
      or node:type() == 'method_declaration'
      or node:type() == 'func_literal'
      or node:type() == 'function_definition'
    then
      -- Get function name
      local name_node = node:field('name')[1]
      if name_node then
        func_name = vim.treesitter.get_node_text(name_node, 0)
      end
      break
    end
    node = node:parent()
  end

  -- Format and copy result
  local reference = string.format('%s:%s:%d\n%s', rel_path, func_name, line_num, line_content)
  vim.fn.setreg('+', reference)
  print('Copied code ref!')
end

vim.keymap.set('n', '<leader>xx', get_code_reference, { noremap = true, silent = true })
