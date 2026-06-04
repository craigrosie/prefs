-- Highlight todo, notes, etc in comments
return {
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      keywords = {
        FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
        TODO = { icon = ' ', color = 'info' },
        HACK = { icon = ' ', color = 'warning' },
        WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
        PERF = { icon = '󰅒 ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = { icon = '󰍨 ', color = 'hint', alt = { 'INFO' } },
        TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
        DEPRECATED = { icon = ' ', color = 'deprecated' },
      },
      colors = {
        error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
        warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
        info = { 'DiagnosticInfo', '#2563EB' },
        hint = { 'DiagnosticHint', '#10B981' },
        default = { 'Identifier', '#7C3AED' },
        test = { 'Identifier', '#FF006E' },
        deprecated = '#FF8800',
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
