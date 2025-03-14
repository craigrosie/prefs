return {
  'stevearc/quicker.nvim',
  event = 'FileType qf',
  opts = {
    keys = {
      {
        '>',
        function()
          require('quicker').expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = 'Expand quickfix context',
      },
      {
        '<',
        function()
          require('quicker').collapse()
        end,
        desc = 'Collapse quickfix context',
      },
    },
  },
  keys = {
    { '<leader>q', ":lua require('quicker').toggle()<CR>", desc = 'Toggle [q]uickfix' },
    { '<leader>l', ":lua require('quicker').toggle({ loclist = true })<CR>", desc = 'Toggle [l]loclist' },
  },
}
