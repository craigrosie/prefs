return {
  'ethanholz/nvim-lastplace',
  event = 'VeryLazy',
  enabled = false,
  opts = {
    lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help', 'terminal' },
    lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'fzf' },
  },
}
