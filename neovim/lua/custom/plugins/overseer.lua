return {
  'stevearc/overseer.nvim',
  opts = {
    task_list = {
      bindings = {
        ['?'] = 'ShowHelp',
        ['g?'] = 'ShowHelp',
        ['<CR>'] = 'RunAction',
        ['<C-e>'] = 'Edit',
        ['o'] = 'Open',
        ['<C-v>'] = 'OpenVsplit',
        ['<C-s>'] = 'OpenSplit',
        ['<C-f>'] = 'OpenFloat',
        ['q'] = 'OpenQuickFix',
        ['p'] = 'TogglePreview',
        ['>'] = 'IncreaseDetail',
        ['<'] = 'DecreaseDetail',
        ['L'] = 'IncreaseAllDetail',
        ['H'] = 'DecreaseAllDetail',
        ['['] = 'DecreaseWidth',
        [']'] = 'IncreaseWidth',
        ['{'] = 'PrevTask',
        ['}'] = 'NextTask',
        ['<C-k>'] = false,
        ['<C-j>'] = false,
      },
    },
  },
  keys = {
    { '<leader>or', ':OverseerRun<CR>', desc = '[o]verseer [r]un' },
    { '<leader>ot', ':OverseerToggle<CR>', desc = '[o]verseer [t]oggle' },
    { '<leader>oa', ':OverseerTaskAction<CR>', desc = '[o]verseer task [a]ction' },
  },
}
