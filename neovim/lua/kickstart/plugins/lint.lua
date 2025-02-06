return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')
    local golangcilint = lint.linters.golangcilint
    golangcilint.args = { 'run', '--allow-parallel-runners', '--out-format', 'json' }
    lint.linters_by_ft = {
      -- markdown = { 'markdownlint', 'vale' },
      dockerfile = { 'hadolint' },
      go = { 'golangcilint' },
      javascript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      make = { 'checkmake' },
      python = { 'ruff', 'mypy' },
      sh = { 'shellcheck' },
      tf = { 'tflint' },
      typescript = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
    }

    -- Create autocommand which carries out the actual linting
    -- on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- hides errors if linters are not installed, however, this could mask hidden issues
        -- require('lint').try_lint(nil, { ignore_errors = true })
        require('lint').try_lint()
      end,
    })
  end,
}
